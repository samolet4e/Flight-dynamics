function xdot = f(t,x) % ode45

  global g U0 m Ixx Iyy Izz Ixz Xu Xw Xde Xdf Yv Yda Ydr Zu Zw Zde Zdf ...
  Lb Lp Lr Lda Ldr Mu Mw Mwdot Mq Mde Mdf Nb Np Nr Nda Ndr;

  persistent Lv = Lb/U0;
  persistent Nv = Nb/U0;

  U = x(1); V = x(2); W = x(3);
  P = x(4); Q = x(5); R = x(6);
  theta = x(7); phi = x(8);

  % Change control linputs here!
  df = 0.*pi/180.; % flaps, rad
%  de = 0.*pi/180.; % elevator, rad
  de = ((t>=0) - (t>10))/50.; % elevator, rad
  da = 0.*pi/180.; % aileron, rad
%  da = ((t>=0) - (t>10))/50.; % aileron, rad
  dr = 0.*pi/180.; % rudder, rad

  X_m = Xu*(U - U0) + Xw*W + Xde*de + Xdf*df;
  Y_m = Yv*V + Yda*da + Ydr*dr;
  Z_m = Zu*(U - U0) + Zw*W + Zde*de + Zdf*df;

  G = [-g*sin(theta), g*cos(theta)*sin(phi), g*(cos(theta)*cos(phi) - 1.)];

  udot = X_m + R*V - Q*W + G(1);
  vdot = Y_m + P*W - U*R + G(2);
  wdot = Z_m + Q*U - P*V + G(3);

  L = Ixx*(Lv*V + Lp*P + Lr*R + Lda*da + Ldr*dr);
  M = Iyy*(Mu*(U - U0) + Mw*W + Mwdot*wdot + Mq*Q + Mde*de + Mdf*df);
  N = Izz*(Nv*V + Np*P + Nr*R + Nda*da + Ndr*dr);

  pdot = 1./(Ixx*Izz - Ixz^2.)*(Ixz*(-Iyy*P*Q + N + Q*(Ixx*P - Ixz*R)) + Izz*(Iyy*Q*R + L + Q*(Ixz*P - Izz*R)));
  qdot = 1./Iyy*(M - P*(Ixz*P - Izz*R) - R*(Ixx*P - Ixz*R));
  rdot = 1./(Ixx*Izz - Ixz^2.)*(Ixx*(-Iyy*P*Q + N + Q*(Ixx*P - Ixz*R)) + Ixz*(Iyy*Q*R + L + Q*(Ixz*P - Izz*R)));

	xdot(1) = udot;
	xdot(2) = vdot;
	xdot(3) = wdot;

	xdot(4) = pdot;
	xdot(5) = qdot;
	xdot(6) = rdot;

  xdot(7) = Q*cos(phi) - R*sin(phi);
  xdot(8) = P + R*tan(theta)*cos(phi) + Q*tan(theta)*sin(phi);

end

