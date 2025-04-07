
% ------------------------------------------------------------------------------
% Tabela 22-14 (str. 727)
% Æwiczenie: Dopasowywanie obrazów metod¹ maksymalizacji informacji wzajemnej
% ------------------------------------------------------------------------------
 
function I2 = affine_tz(I1, parametry);
% obraz I2 = wynik transformacji afinicznej obrazu 1

bx = parametry(1);  by = parametry(2); bxy = parametry(3); 
th = parametry(4);  tx = parametry(5); ty  = parametry(6); 

a11 = bxy*sin(th)+bx*cos(th);
a12 = bxy*cos(th)-bx*sin(th);
a21 = by*sin(th);
a22 = by*cos(th);

A = [a11 a12 0; a21 a22 0; tx ty 1];
tform = maketform('affine',A);

s = 255; [vv uu] = size(I1);
vmax = round(vv/2);   vmin=vmax-vv;
umax = round(uu/2);   umin=umax-uu;

[I2,xdata, ydata] = imtransform(I1,tform,'bilinear','UData',[umin umax],'VData',...
                    [vmin vmax],'XData',[umin umax],'YData',[vmin vmax],'FillValues',s);

