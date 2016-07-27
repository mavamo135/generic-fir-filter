function [x] = MUX_VHDL(N)
% Apertura de archivo VHDL
n = size(dec2bin(N));
fid = fopen('MUX.vhd','wt');
fprintf(fid,'library ieee;\n\n');
fprintf(fid,'use IEEE.std_logic_1164.all;\n');
fprintf(fid,'use IEEE.std_logic_unsigned.all;\n\n');
fprintf(fid,'entity MUX is\n');
fprintf(fid,'\tgeneric(\n');
fprintf(fid,'\tN: integer\t:= 8\n\t);\n');
fprintf(fid,'\tport(\n');
fprintf(fid,'\tOPC:\tin std_logic_vector(%d downto 0);\n',n(2)-1);
for k=1:1:N+1
    fprintf(fid,'\tD%d :\tin std_logic_vector(N-1 downto 0);\n',k-1);
end
fprintf(fid,'\tDout:\tout std_logic_vector(N-1 downto 0)\n\t);\n');
fprintf(fid,'end MUX;\n\n');
fprintf(fid,'architecture MUXA of MUX is\n');
fprintf(fid,'begin\n\n');
fprintf(fid,'\tprocess(OPC');
for k=1:1:N+1
    fprintf(fid,',D%d',k-1);
end
fprintf(fid,')\n');
fprintf(fid,'\tbegin\n');
fprintf(fid,'\t\tcase OPC is\n');
for k=1:1:N
    fprintf(fid,'\t\t\twhen "');
    bin = de2bi(k-1,n(2));
    s = size(bin);
    for m=0:1:s(2)-1
        fprintf(fid,'%d',bin(s(2)-m));
    end
    fprintf(fid,'" =>\n');
    fprintf(fid,'\t\t\t\tDout <= D%d;\n',k-1);
end
fprintf(fid,'\t\t\twhen others =>\n');
fprintf(fid,'\t\t\t\tDout <= D%d;\n',N);
fprintf(fid,'\t\tend case;\n');
fprintf(fid,'\tend process;\n\n');
fprintf(fid,'end MUXA;');
fclose(fid);
x=1;
end