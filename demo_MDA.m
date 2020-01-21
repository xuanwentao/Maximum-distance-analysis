clear all;
clc;
tic;
load('data6');
%% The first endmember
D_O = sum(mixed.^2,2).^(1/2);
[V_p,E_lab1]=max(D_O);
E(1,:)=E_lab1(1,1);
%% The second endmember 
D_1p = sum((mixed(E_lab1(1,1),:)-mixed).^2,2).^(1/2);
[V_1p,E_lab2] = max(D_1p);
E(2,:)=E_lab2;
%% The third endmember
v_12=(mixed(E_lab2,:)-mixed(E_lab1(1,1),:));
v_2p = mixed-mixed(E_lab2,:);
cos = v_2p*v_12'./((sum(v_2p.^2,2).^(1/2))*(sum(v_12.^2,2).^(1/2)));
norm_v_p2 = sum(v_2p.^2,2).^(1/2);%求p2的长度
angle = acos((cos));
D_p_12 = norm_v_p2.*sin(angle(:));
[V_p_12,E_lab3]=max(D_p_12);
E(3,:)=E_lab3;
%% The forth endmember
E_3 = mixed(E,:);
r =rank(E_3);
Gen_sol = null(E_3,r);
n = Gen_sol(:,1);
[V_p_123,E_lab4] = max(abs(v_2p*n)/norm(n));
E(4,:) = E_lab4;
%% The next endmember
for i = 5:100
A5 = mixed(E,:);
r5 = rank(A5);
Gen_sol5 = null(A5,r5);
n5 = Gen_sol5(:,1);
x=mixed(E(1,1),:);
b5 = abs((x*n5)/norm(n5));
DL5=mixed*n5+b5;
dis5 = (sum(abs(DL5).^2,2).^(1/2))/norm(n5);
[rol5,cow5]=sort(dis5,'descend');
if rol5(1,1)>0.00001
    E(i,:)=cow5(1,1);
    a = rol5(1,1)
else
    break
end
end
%%
mixed = mixed';
Aest = mixed(:,E);
Nx = 58;Ny = 58;Nb = 188;
[E_aad,E_aid,E_sad,E_sid,E_rmse] = performance_metrics(A,Aest,mixed,abf,Nx,Ny,Nb,c);
toc;



