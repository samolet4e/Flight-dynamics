% >> pkg load control
clear;

load dc-8_SI.in;

% 6a6mi razni
Mu  += Mwdot*Zu;
Mw  += Mwdot*Zw;
Mq  += Mwdot*U0;
Mde += Mwdot*Zde;

A = [
  Xu,Xw,0.,-g;
  Zu,Zw,U0,0.;
  Mu,Mw,Mq,0.;
  0.,0.,1.,0.
];
%{
B = [
  Xde,Xdf,-Xu,-Xw,0.;
  Zde,Zdf,-Zu,-Zw,-U0;
  Mde,Mdf,-Mu,-Mw,-Mq;
  0.,0.,0.,0.,-1.
];
%}
% u = |de, df|
B = [
  Xde,Xdf;
  Zde,Zdf;
  Mde,Mdf;
  0.,0.
];

C = [
  0.,1./U0,0.,0.;
  0.,1./U0,0.,1.;
  Zu,Zw,0.,0.
];
%{
D = [
  0.,0.,0.,0.,0.;
  0.,0.,0.,0.,0.;
  Zde,Zdf,-Zu,-Zw,-U0
];
%}

D = [
  0.,0.;
  0.,0.;
  Zde,Zdf
];

sys = ss(A,B,C,D);

t = linspace(0.,100.,1000);
u = ((t>=0) - (t>10))/50.; % rad
%v = zeros(size(t)(2),4);
v = zeros(size(t)(2),1);
u = [u',v];
[y,t,x] = lsim(sys,u,t);

figure(1);
for i=1:3
  subplot(3,1,i);
  plot(t,y(:,i));
  switch (i)
    case 1
      ylabel('alpha, rad');
    case 2
      ylabel('gamma, rad');
    case 3
      ylabel('aZ, m/s^2');
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
      ylabel('u, m/s');
    case 2
      ylabel('w, m/s');
    case 3
      ylabel('q, 1/s');
    case 4
      ylabel('theta, rad');
  end
  xlabel('t, s');
  grid on
end

file_id = fopen('linLong.txt','w+');
fprintf(file_id,"%f\t%f\t%f\t%f\n",x(:,1),x(:,2),x(:,3),x(:,4));
fclose(file_id);

