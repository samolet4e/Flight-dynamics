% >> pkg load control
clear;

load dc-8_SI.in;

Lbp = Lb + Ixz/Ixx*Nb;
Lpp = Lp + Ixz/Ixx*Np;
Lrp = Lr + Ixz/Ixx*Nr;
Nbp = Nb + Ixz/Izz*Lb;
Npp = Np + Ixz/Izz*Lp;
Nrp = Nr + Ixz/Izz*Lr;

Ldap = Lda + Ixz/Ixx*Nda;
Ldrp = Ldr + Ixz/Ixx*Ndr;
Ydap = Yda/U0;
Ndap = Nda + Ixz/Izz*Lda;
Ndrp = Ndr + Ixz/Izz*Ldr;
Ydrp = Ydr/U0;

A = [
  Yv,0.,-1.,g/U0;
  Lbp,Lpp,Lrp,0.;
  Nbp,Npp,Nrp,0.;
  0.,1.,0.,0.;
];
%{
B = [
  Ydap,Ydrp,-Yv,0.,1.;
  Ldap,Ldrp,-Lbp,-Lpp,-Lrp;
  Ndap,Ndrp,-Nbp,-Npp,-Nrp;
  0.,0.,0.,-1.,0.;
];
%}

B = [
  Ydap,Ydrp;
  Ldap,Ldrp;
  Ndap,Ndrp;
  0.,0.;
];

C = [
  U0,0.,0.,0.;
  Yv*U0,0.,0.,0.
];
%{
D = [
  0.,0.,0.,0.,0.;
  Ydap*U0,Ydrp*U0,-Yv*U0,0.,U0
];
%}

D = [
  0.,0.;
  Ydap*U0,Ydrp*U0
];

sys = ss(A,B,C,D);

t = linspace(0.,100.,1000);
u = ((t>=0) - (t>10))/50.; % rad
%v = zeros(size(t)(2),4);
v = zeros(size(t)(2),1);
u = [u',v];
[y,t,x] = lsim(sys,u,t);

figure(1);
for i=1:2
  subplot(2,1,i);
  plot(t,y(:,i));
  switch (i)
    case 1
      ylabel('v, m/s');
    case 2
      ylabel('aY, m/s^2');
  end
  xlabel('t, s');
  grid on
end

figure(2);
for i=1:4
  subplot(2,2,i);
  plot(t,x(:,i));
  switch (i)
    case 1
      ylabel('beta, rad');
    case 2
      ylabel('p, 1/s');
    case 3
      ylabel('r, 1/s');
    case 4
      ylabel('phi, rad');
  end
  xlabel('t, s');
  grid on
end

file_id = fopen('linLat.txt','w+');
fprintf(file_id,"%f\t%f\t%f\t%f\n",x(:,1),x(:,2),x(:,3),x(:,4));
fclose(file_id);
