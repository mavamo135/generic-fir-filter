function [x] = FIR_Test_Bench_VHDL(NO,Fs,F_signal,F_signal1,F_signal2)
% Ancho de la memoria
NI = 10; %establecido para cuando se cargan los datos ya generados
% Ancho de la palabra
W = 12;
% Factores intermedios
NN = 2^NI;
% Apertura de archivo VHDL
fid = fopen('Test_Bench_FIR.vhd','wt');
fprintf(fid,'library ieee;\n\n');
fprintf(fid,'use IEEE.std_logic_1164.all;\n');
fprintf(fid,'use IEEE.std_logic_unsigned.all;\n\n');
fprintf(fid,'use IEEE.std_logic_arith.all;\n\n');
fprintf(fid,'entity TestFIR is\n');
fprintf(fid,'\tgeneric(\n');
fprintf(fid,'\tN: integer\t:= 13;--bits de la senal de entrada del convertidor\n');
fprintf(fid,'\tM: integer\t:= 18;--bits de los coeficientes\n');
n = size(dec2bin(NO));
fprintf(fid,'\tK: integer\t:= %d  --bits del orden del filtro\n\t);\n',n(2));
fprintf(fid,'end TestFIR;\n\n');
fprintf(fid,'architecture prueba of TestFIR is\n');
fprintf(fid,'signal CLK\t\t:std_logic;\n');
fprintf(fid,'signal RST\t\t:std_logic;\n');
fprintf(fid,'signal STP\t\t:std_logic;\n');
fprintf(fid,'signal EOP\t\t:std_logic;\n');
fprintf(fid,'signal X\t\t:std_logic_vector(N-1 downto 0);\n');
fprintf(fid,'signal Orden\t:std_logic_vector(K-1 downto 0);\n');
fprintf(fid,'signal Y\t\t:std_logic_vector(N-1 downto 0);\n');
fprintf(fid,'signal XK\t\t:std_logic_vector(N-2 downto 0);\n');
fprintf(fid,'begin\n\n');
fprintf(fid,'\tX <= %c0%c&XK;\n','''','''');
n = size(dec2bin(NO));
fprintf(fid,'\tOrden <= "');
bin = de2bi(NO,n(2));
s = size(bin);
for m=0:1:s(2)-1
    fprintf(fid,'%d',bin(s(2)-m));
end
fprintf(fid,'";\n');
fprintf(fid,'\tU0: entity work.FIR generic map(N,M,K) port map(CLK,RST,STP,X,Orden,Y,EOP);\n\n');
fprintf(fid,'\tReset:process\n');
fprintf(fid,'\tbegin\n');
fprintf(fid,'\t\tRST <= %c0%c;\n','''','''');
fprintf(fid,'\t\twait for 20 ns;\n');
fprintf(fid,'\t\tRST <= %c1%c;\n','''','''');
fprintf(fid,'\t\twait;\n');
fprintf(fid,'\tend process Reset;\n\n');
fprintf(fid,'\tReloj:process\n');
fprintf(fid,'\tbegin\n');
fprintf(fid,'\t\tCLK <= %c0%c;\n','''','''');
fprintf(fid,'\t\twait for 10 ns;\n');
fprintf(fid,'\t\tCLK <= %c1%c;\n','''','''');
fprintf(fid,'\t\twait for 10 ns;\n');
fprintf(fid,'\tend process Reloj;\n\n');
fprintf(fid,'\tComienzo:process\n');
fprintf(fid,'\tbegin\n');
fprintf(fid,'\t\tSTP <= %c0%c;\n','''','''');
fprintf(fid,'\t\twait for 999980 ns;\n');
fprintf(fid,'\t\tSTP <= %c1%c;\n','''','''');
fprintf(fid,'\t\twait for 20 ns;\n');
fprintf(fid,'\tend process Comienzo;\n\n');
fprintf(fid,'\tSenal:process\n');
fprintf(fid,'\tbegin\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 3
% Calculo de la funcion
% Calculo directo de la funcion normalizada [-1,1]
for i=0:NN-1
    P1 = 2.0*pi*F_signal*i/(Fs);
    P2 = 2.0*pi*F_signal1*i/(Fs);
    P3 = 2.0*pi*F_signal2*i/(Fs);
    S(i+1) = 0.5 + (0.1*sin(P1)) + (0.1*sin(P2)) + (0.15*sin(P3));
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 4
% Cuantizacion
% Binarizacion de la fase
for i=0:NN-1
    Aux = i;
    for j=NI-1:-1:0
        R = 2*(Aux/2 - floor(Aux/2));
        IDX(i+1,j+1) = R;
        Aux = floor(Aux/2);
    end;
end;
% Bits enteros = 2 para funciones normalizadas
e = 0;
% Bits fraccionarios
f = W - e;
% Factor de cuantizacion
Fq = 2^f;
% Cuantizacion de la funcion
SQ = floor(S*Fq + 0.5);
% Escalamiento de la funcion cuantizada
SS = SQ/Fq;
% Binarizacion de la funcion en complemento 2
for i=1:NN
    % Ajuste a entero positivo equivalente en complemento 2
    Auxiliar = SQ(i);
    if (Auxiliar < 0)
        Auxiliar = 2^W + Auxiliar;
    end;
    % Binarizacion
    for j=W:-1:1
        ABI(i,j) = rem(Auxiliar,2);
        Auxiliar = floor(Auxiliar/2);
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parte 5
% Generacion automatica de la LUT en VHDL
% Vaciado automatico de la tabla de equivalencias
fprintf(fid,'\t\tXK <= "000000000000";\n');
fprintf(fid,'\t\twait for 1000000 ns;\n');
for i=1:NN
    % fprintf(fid,'         when "');
    % Binarizacion de la fase
    %for j=1:N
    %    fprintf(fid,'%d',IDX(i,j));
    %end;
    fprintf(fid,'\t\tXK <= "');
    % Binarizacion de la funcion
    for j=1:W
        fprintf(fid,'%d',ABI(i,j));
    end;
    fprintf(fid,'"; -- Indice %d   Valor de la funcion %1.8f\n',i-1,SS(i));
    fprintf(fid,'\t\twait for 1000000 ns;\n');
end;
fprintf(fid,'\tend process Senal;\n\n');
fprintf(fid,'\nend prueba;');
fclose(fid);
x=1;
end