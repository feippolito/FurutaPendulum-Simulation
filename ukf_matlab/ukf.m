function [x,P]=ukf(x,P,z,Q,R)
L=numel(x); %numer of states
m=numel(z); %numer of measurements
alpha=1e-3; %default, tunable
ki=0; %default, tunable
beta=2; %default, tunable
lambda=alpha^2*(L+ki)-L; %scaling factor
c=L+lambda; %scaling factor
Wm=[lambda/c 0.5/c+zeros(1,2*L)]; %weights for means
Wc=Wm;
Wc(1)=Wc(1)+(1-alpha^2+beta); %weights for covariance
c=sqrt(c);
X=sigmas(x,P,c); %sigma points around x
[x1,X1,P1,X2]=utf(X,Wm,Wc,L,Q); %unscented transformation of process
% X1=sigmas(x1,P1,c); %sigma points around x1
% X2=X1-x1(:,ones(1,size(X1,2))); %deviation of X1
[z1,Z1,P2,Z2]=uth(X1,Wm,Wc,m,R); %unscented transformation of measurments
P12=X2*diag(Wc)*Z2'; %transformed cross-covariance
K=P12*pinv(P2);
x=x1+K*(z-z1); %state update
P=P1-K*P12'; %covariance update

