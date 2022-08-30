clear;
clc;
% Nonlinear regression for multiple variables

	% 1-3列为日期，4列气温日较差,5列日照百分率,6列总辐射，7列天文辐射，8列总辐射/天文辐射
		filename = '/Users/skylar/Downloads/out_jsdata/50136.txt';
		data = load(filename);

		%timespan = 30*12*5; % here set 5 years as a baseline  


	% H                : 日总辐射   (6)
	% H0               : 天文辐射   (7)
	% T_diff=Tmax-Tmin : 温度日较差 (4)

	% Fomula:
	%           H = H0 * a[1-exp(-B(Tmax-Tmin)^C)]
	%           H = H0 * a[1-exp(-B*T_diff^C)]
	%           Transmit = H/H0 = a[1-exp(-B*T_diff^C)]

		%T_diff   = data(1:timespan,4);
		%H        = data(1:timespan,6);
		%H0       = data(1:timespan,7);
		%Transmit = data(1:timespan,8);

		T_diff   = data(:,4);
		H        = data(:,6);
		H0       = data(:,7);
		Transmit = data(:,8);



	% multiple-variable nonlinear regression
		Y     = Transmit
		X     = [T_diff];

		% H = H0 * a[1-exp(-B*T_diff^C)]  =====>> H = H0 * coeff(1)[1-exp(-coeff(2)*T_diff^coeff(3))]
		% a     = coeff(1);
		% B     = coeff(2);
		% C     = coeff(3);
 
		%modelfunc = @(coeff,X)(coeff(1).*X(:,1).*(1-exp(-coeff(2).*X(:,2).^coeff(3))))
		modelfunc = @(coeff,X)(coeff(1).*(1-exp(-coeff(2).*X(:,1).^coeff(3))))

		% first guess of B and C on based on the reference from Bristow & Campbell (1984)

			coeff0 = [1, 0,0];%待定系数的预估值
			coeff0(2) = 0.036* exp(-0.154*(mean(T_diff)))
			coeff0(3) = 2.4		

		%coeff0 =rand(3,1);

		% 三个回归系数
		coeff = nlinfit(X,Y,modelfunc,coeff0);

		% results:
			a     = coeff(1)
			B     = coeff(2)
			C     = coeff(3)





