function flag=LMI_Aut18_prop1(a,L,r,h,etaM,dL,dR,alpha0,alpha1,OmegaM)
% This MATLAB program checks the feasibility of LMIs from Proposition 1 of the paper 
% A. Selivanov and E. Fridman, "Delayed point control of a reaction-diffusion PDE 
% under discrete-time point measurements," Automatica, vol. 96, pp. 224-233, 2018. 

% The program uses YALMIP parser (http://users.isy.liu.se/johanl/yalmip/)

% Input: 
% a         - reaction coefficient 
% L         - observer gain
% r         - input delay 
% h         - sampling period
% etaM      - maximum network-induced delay 
% dL, dR    - boundary conditions 
% alpha0    - decay rate
% alpha1    - tuning parameter
% OmegaM    - maximum subdomain size 

% Output: 
% flag =1 if feasible, =0 otherwise

sdpvar G S1 S2 R1 R2 p1 p2  % Decision variables  
tauM=h+etaM+r;              % Overall delay 
%% LMIs 
Phi=blkvar; 
Phi(1,1)=-R1*exp(-alpha1*r)+S1+2*p1*(a+alpha0)+alpha1-pi^2*(2*p1-alpha1*p2)*max([dL, dR])/(4-3*dL*dR);
Phi(1,2)=1-p1+p2*(a+alpha0); 
Phi(1,3)=R1*exp(-alpha1*r); 
Phi(1,4)=p1*L; 
Phi(1,6)=p1*L;  
Phi(2,2)=-2*p2+r^2*R1+(h+etaM)^2*R2; 
Phi(2,4)=p2*L; 
Phi(2,6)=p2*L; 
Phi(3,3)=-(R1+S1-S2)*exp(-alpha1*r)-R2*exp(-alpha1*tauM); 
Phi(3,4)=(R2-G)*exp(-alpha1*tauM); 
Phi(3,5)=G*exp(-alpha1*tauM); 
Phi(4,4)=-2*(R2-G)*exp(-alpha1*tauM)-alpha1; 
Phi(4,5)=(R2-G)*exp(-alpha1*tauM); 
Phi(5,5)=-(R2+S2)*exp(-alpha1*tauM); 
Phi(6,6)=-alpha1*p2*pi^2/(4*OmegaM^2); 
Phi=sdpvar(Phi); 

Park=[R2 G; G R2]; 
%% Solution of the system 
LMIs=[Phi<=0, alpha1*p2<=2*p1, Park>=0, S1>=0, S2>=0, R1>=0, R2>=0]; 

options=sdpsettings('solver','lmilab','verbose',0);
sol=optimize(LMIs,[],options); 

flag=0; 
if sol.problem==0 
    [primal,~]=check(LMIs); 
    flag=min(primal)>=0; 
else
    yalmiperror(sol.problem)
end
