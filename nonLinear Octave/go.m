clear;

global g U0 m Ixx Iyy Izz Ixz Xu Xw Xde Xdf Yv Yda Ydr Zu Zw Zde Zdf ...
Lb Lp Lr Lda Ldr Mu Mw Mwdot Mq Mde Mdf Nb Np Nr Nda Ndr;

load dc-8_SI.in;

t = linspace(0.,100.,1000);
% u,v,w,p,q,r,theta,phi
ic = [U0,0.,0.,0.,0.,0.,0.,0.];
[t,x] = ode45(@(t,x)f(t,x),t,ic);

rx = cumtrapz(t,x(:,1));
ry = cumtrapz(t,x(:,2));
rz = cumtrapz(t,x(:,3));

figure(1);
plot3(rx,ry,rz,'-','linewidth',2);
xlabel('X, m'); ylabel('Y, m'); zlabel('Z, m');
grid on

motion = 'longitudinal';

figure(2);
switch (motion)

  case 'longitudinal'

    subplot(2,2,1);
    plot(t,x(:,1)-x(1,1));
    ylabel('u, m/s');
    xlabel('t, s');
    grid on

    subplot(2,2,2);
    plot(t,x(:,3));
    ylabel('w, m/s');
    xlabel('t, s');
    grid on

    subplot(2,2,3);
    plot(t,x(:,5));
    ylabel('q, 1/s');
    xlabel('t, s');
    grid on

    subplot(2,2,4);
    plot(t,x(:,7));
    ylabel('theta, rad');
    xlabel('t, s');
    grid on

    file_id = fopen('nonLinLong.txt','w+');
    fprintf(file_id,"%f\t%f\t%f\t%f\n",x(:,1)-x(1,1),x(:,3),x(:,5),x(:,7));
    fclose(file_id);

  case 'lateral'

    u = x(:,1); v = x(:,2); w = x(:,3);
    V = sqrt(u.^2 + v.^2 + w.^2);
%    alpha = atan(w/u);
    beta = asin(v./V);

    subplot(2,2,1);
    plot(t,beta);
    ylabel('beta, rad');
    xlabel('t, s');
    grid on

    subplot(2,2,2);
    plot(t,x(:,4));
    ylabel('p, 1/s');
    xlabel('t, s');
    grid on

    subplot(2,2,3);
    plot(t,x(:,6));
    ylabel('r, 1/s');
    xlabel('t, s');
    grid on

    subplot(2,2,4);
    plot(t,x(:,8));
    ylabel('phi, rad');
    xlabel('t, s');
    grid on

    file_id = fopen('nonLinLat.txt','w+');
    fprintf(file_id,"%f\t%f\t%f\t%f\n",beta,x(:,4),x(:,6),x(:,8));
    fclose(file_id);

end

