function [x] = FIR_VHDL(N,K)
% Apertura de archivo VHDL
fid = fopen('FIR.vhd','wt');
fprintf(fid,'library ieee;\n\n');
fprintf(fid,'use IEEE.std_logic_1164.all;\n');
fprintf(fid,'use IEEE.std_logic_unsigned.all;\n\n');
fprintf(fid,'entity FIR is\n');
fprintf(fid,'\tgeneric(\n');
fprintf(fid,'\tN: integer\t:= 13;--bits de la senal de entrada del convertidor\n');
fprintf(fid,'\tM: integer\t:= 18;--bits de los coeficientes\n');
fprintf(fid,'\tK: integer\t:= %d  --bits del orden del filtro\n\t);\n',K);
fprintf(fid,'\tport(\n');
fprintf(fid,'\tCLK  :\tin std_logic;\n');
fprintf(fid,'\tRST  :\tin std_logic;\n');
fprintf(fid,'\tSTP  :\tin std_logic;\n');
fprintf(fid,'\tX    :\tin std_logic_vector(N-1 downto 0);\n');
fprintf(fid,'\tOrden:\tin std_logic_vector(K-1 downto 0);\n');
fprintf(fid,'\tY    :\tout std_logic_vector(N-1 downto 0);\n');
fprintf(fid,'\tEOP  :\tout std_logic\n\t);\n');
fprintf(fid,'end FIR;\n\n');
fprintf(fid,'architecture Filtro of FIR is\n');
fprintf(fid,'signal I\t\t:std_logic_vector(K-1 downto 0);\n');
fprintf(fid,'signal Coef\t\t:std_logic_vector(M-1 downto 0);\n');
for k=0:1:N
    fprintf(fid,'signal X_%d\t\t:std_logic_vector(N-1 downto 0);\n',k);
end
fprintf(fid,'signal Xout\t\t:std_logic_vector(N-1 downto 0);\n');
fprintf(fid,'signal EOPMAC\t:std_logic;\n');
fprintf(fid,'signal Igual\t:std_logic;\n');
fprintf(fid,'signal STPMAC\t:std_logic;\n');
fprintf(fid,'signal H\t\t:std_logic;\n');
fprintf(fid,'begin\n\n');
fprintf(fid,'\tX_0 <= X;\n');
fprintf(fid,'\tU0: entity work.MAC generic map(N,M,K) port map(CLK,RST,STPMAC,Xout,Coef,Orden,Y,I,EOPMAC);\n');
fprintf(fid,'\tU1: entity work.ROM_FIR port map(I,Coef);\n');
fprintf(fid,'\tU2: entity work.FSM_FIR port map(CLK,RST,STP,EOPMAC,STPMAC,H,EOP);\n');
fprintf(fid,'\tU3: entity work.MUX generic map(N) port map(I');
for k=0:1:N
    fprintf(fid,',X_%d',k);
end
fprintf(fid,',Xout);\n');
for k=0:1:N-1
    fprintf(fid,'\tU%d: entity work.Registro_Paralelo_Hold generic map(N) port map(CLK,RST,H,X_%d,X_%d); --X(n-%d)\n',k+4,k,k+1,k+1);
end	
fprintf(fid,'\nend Filtro;');
fclose(fid);
x=1;
end