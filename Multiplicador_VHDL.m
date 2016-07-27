function [x] = Multiplicador_VHDL()
% Apertura de archivo VHDL
fid = fopen('Multiplicador_nm_ss.vhd','wt');
fprintf(fid,'library ieee;\n\n');
fprintf(fid,'use IEEE.std_logic_1164.all;\n');
fprintf(fid,'use IEEE.std_logic_arith.all;\n');
fprintf(fid,'use IEEE.std_logic_unsigned.all;\n\n');
fprintf(fid,'entity Multiplicador_nm_ss is\n');
fprintf(fid,'\tgeneric(\n');
fprintf(fid,'\tN: integer\t:= 8;\n');
fprintf(fid,'\tM: integer\t:= 8\n\t);\n');
fprintf(fid,'\tport(\n');
fprintf(fid,'\tX:\tin std_logic_vector(N-1 downto 0);\n');
fprintf(fid,'\tA:\tin std_logic_vector(M-1 downto 0);\n');
fprintf(fid,'\tR:\tout std_logic_vector(N+M-1 downto 0)\n\t);\n');
fprintf(fid,'end Multiplicador_nm_ss;\n\n');
fprintf(fid,'architecture Aritmetica of Multiplicador_nm_ss is\n');
fprintf(fid,'begin\n\n');
fprintf(fid,'\tprocess(X,A)\n');
fprintf(fid,'\tvariable Q : signed(N+M-1 downto 0);\n');
fprintf(fid,'\tbegin\n');
fprintf(fid,'\t\tQ := signed(X)*signed(A);\n');
fprintf(fid,'\t\tR <= std_logic_vector(Q);\n');
fprintf(fid,'\tend process;\n\n');
fprintf(fid,'end Aritmetica;');
fclose(fid);
x=1;
end