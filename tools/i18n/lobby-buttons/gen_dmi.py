from PIL import Image
import zlib, struct
from collections import Counter
BDF="fusion-pixel-10px-proportional-zh_hans.bdf"
OUT="modular_zh/modules/i18n/icons/lobby"

def parse_bdf(p):
    g={};cur=None;it=iter(open(p,encoding='latin1'))
    for line in it:
        if line.startswith('ENCODING'):cur={'cp':int(line.split()[1])}
        elif line.startswith('DWIDTH'):cur['dw']=int(line.split()[1])
        elif line.startswith('BBX'):_,w,h,xo,yo=line.split();cur['bbx']=(int(w),int(h),int(xo),int(yo))
        elif line.startswith('BITMAP'):
            rows=[]
            for b in it:
                if b.startswith('ENDCHAR'):break
                rows.append(b.strip())
            cur['rows']=rows;g[cur['cp']]=cur
    return g
G=parse_bdf(BDF); ASC=11
def textimg(text,color):
    lay=Image.new("RGBA",(220,16),(0,0,0,0));px=lay.load();pen=0
    for ch in text:
        gl=G.get(ord(ch))
        if not gl:pen+=8;continue
        w,h,xo,yo=gl['bbx'];top=ASC-(yo+h)
        for r,hx in enumerate(gl['rows']):
            v=int(hx,16);nb=len(hx)*4
            for x in range(w):
                if (v>>(nb-1-x))&1:px[pen+xo+x,top+r]=color
        pen+=gl['dw']
    bb=lay.getbbox();return lay.crop(bb) if bb else lay

def ztxt(path):  # extract original DMI metadata chunk bytes
    d=open(path,"rb").read();i=8
    while i<len(d):
        ln=struct.unpack(">I",d[i:i+4])[0]
        if d[i+4:i+8]==b"zTXt": return d[i:i+12+ln]
        i+=12+ln
def meta(path):
    d=open(path,"rb").read();i=8;m=None
    while i<len(d):
        ln=struct.unpack(">I",d[i:i+4])[0]
        if d[i+4:i+8]==b"zTXt":
            _,rest=d[i+8:i+8+ln].split(b"\x00",1);m=zlib.decompress(rest[1:]).decode("latin1")
        i+=12+ln
    w=h=0;st=[]
    for L in m.splitlines():
        L=L.strip()
        if L.startswith("width ="):w=int(L.split("=")[1])
        elif L.startswith("height ="):h=int(L.split("=")[1])
        elif L.startswith("state ="):st.append([L.split("=")[1].strip().strip('"'),1])
        elif L.startswith("frames ="):st[-1][1]=int(L.split("=")[1])
    return w,h,st

def clusters(cell,W,H):
    px=cell.load();ys={}
    for y in range(H):
        for x in range(W):
            r,g,b,a=px[x,y]
            if a>200 and max(r,g,b)-min(r,g,b)>45 and max(r,g,b)>110:
                ys.setdefault(y,[]).append((x,(r,g,b,255)))
    if not ys:return []
    rows=sorted(ys);cl=[];cur=[rows[0]]
    for y in rows[1:]:
        (cur.append(y) if y-cur[-1]<=2 else (cl.append(cur),cur:=[y]))
    cl.append(cur)
    out=[]
    for c in cl:
        xs=[x for y in c for x,_ in ys[y]];cols=[col for y in c for _,col in ys[y]]
        out.append((min(xs),c[0],max(xs),c[-1],Counter(cols).most_common(1)[0][0]))
    return out

def bg_of(cell,box):
    px=cell.load();x0,y0,x1,y1=box;c=Counter()
    for y in range(max(0,y0-1),y1+2):
        for x in range(max(0,x0-2),x1+3):
            r,g,b,a=px[x,y]
            if a>200 and not(max(r,g,b)-min(r,g,b)>45 and max(r,g,b)>110): c[(r,g,b,255)]+=1
    return c.most_common(1)[0][0] if c else (30,30,38,255)

def localize(cell,W,H,lines):
    cl=clusters(cell,W,H)
    if not cl:return cell
    for i,(x0,y0,x1,y1,col) in enumerate(cl):
        if i>=len(lines):break
        bg=bg_of(cell,(x0,y0,x1,y1))
        for y in range(y0,y1+1):
            for x in range(x0,x1+1):
                cell.putpixel((x,y),bg)
        t=textimg(lines[i],col)
        cell.alpha_composite(t,((x0+x1)//2-t.width//2,(y0+y1)//2-t.height//2))
    return cell

def textfor(btn,state):
    if btn=="join":return ["加入游戏"]
    if btn=="observe":return ["旁观"]
    if btn=="ready":return ["未准备"] if state.startswith("not_ready") else ["准备就绪"]
    if btn=="character_setup":return ["角色","设置"]
    return []

for btn in ["join","observe","ready","character_setup"]:
    path=f"icons/hud/lobby/{btn}.dmi";W,H,st=meta(path)
    sheet=Image.open(path).convert("RGBA");cols=sheet.width//W;idx=0
    for name,frames in st:
        for fr in range(frames):
            cx=(idx%cols)*W;cy=(idx//cols)*H;idx+=1
            cell=sheet.crop((cx,cy,cx+W,cy+H))
            loc=localize(cell.copy(),W,H,textfor(btn,name))
            sheet.paste(loc,(cx,cy))
    # save PNG + reinject original zTXt metadata
    import io;buf=io.BytesIO();sheet.save(buf,"PNG");d=buf.getvalue()
    ihdr_end=8+25
    out=d[:ihdr_end]+ztxt(path)+d[ihdr_end:]
    open(f"{OUT}/{btn}.dmi","wb").write(out)
    print(f"wrote {OUT}/{btn}.dmi ({len(out)} bytes, {idx} cells)")
