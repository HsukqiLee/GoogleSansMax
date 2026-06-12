import re

with open(r'Q:\Android\GoogleSansMax\webroot\index.html', 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if line.strip().startswith('const HENTAIGANA'):
        chars = ''.join(chr(0x1B001 + j) for j in range(256))
        lines[i] = f"const HENTAIGANA = '{chars}';\n"
        break

with open(r'Q:\Android\GoogleSansMax\webroot\index.html', 'w', encoding='utf-8') as f:
    f.writelines(lines)

print('Fixed HENTAIGANA line')
