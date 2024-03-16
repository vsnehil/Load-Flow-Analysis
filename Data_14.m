global busdata14
% For nrlfppg program
% type: 0-slack bus
%       1-gen bus
%       2-load bus


%%%% Calculation for IEEE 14Bus system......

  % % %     |Bus  | Vsp  |  Psp  |  Qsp    |Type|  Qmin |  Qmax |
  
busdata14 = [  1    1.060    0.0     0.0       0      0       0                 
            2    1.045    18.3    29.7      1     -40     50                 
            3    1.010   -94.2    4.4       1      0      40                
            4    1.0     -47.8    3.9       2      0       0                
            5    1.0     -7.6     -1.6      2      0       0                
            6    1.070   -11.2    4.7       1     -6      24                
            7    1.0      0.0     0.0       2      0       0                  
            8    1.090    0.0     17.4      1     -6      24                 
            9    1.0     -29.5    -16.6     2      0       0           
            10   1.0     -9.0     -5.8      2      0       0             
            11   1.0     -3.5     -1.8      2      0       0               
            12   1.0     -6.1     -1.6      2      0       0                
            13   1.0     -13.5    -5.8      2      0       0              
            14   1.0     -14.9    -5.0      2      0       0 ];
       
          qd=[0 0.127 0.19 -0.039 0.016 0.075 0.0 0.0 0.166 0.058 0.018 0.016 0.058 0.05]';
          qg=[0.0 0.4541 0.2528 0.0 0.0 0.1362 0.0 0.1824 0.0 0.0 0.0 0.0 0.0 0.0]';
          pd=[0.0 0.217 0.942 0.478 0.076 0.112 0.0 0.0 0.295 0.09 0.035 0.061 0.135 0.149]';
          pg=[0.0 0.40 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0]';
          

        shunt=[0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 sqrt(-1)*0.19 0.0 0.0 0.0 0.0 0.0];

          shunt_new=[10 13 14];
 
nbus=14;

%%             [line No.| From Bus| To Bus |         Impedence                 B/2      tapping]
  Linedata14=[   1           1        2       0.01938+sqrt(-1)*0.05917       0.02640       1;
                 2           2        3       0.04699+sqrt(-1)*0.19797       0.02190       1
                 3           2        4       0.05811+sqrt(-1)*0.17632       0.01870       1
                 4           1        5       0.05403+sqrt(-1)*0.22304       0.02460       1
                 5           2        5       0.05695+sqrt(-1)*0.17388       0.01700       1
                 6           3        4       0.06701+sqrt(-1)*0.17103       0.01730       1
                 7           4        5       0.01335+sqrt(-1)*0.04211       0.0064        1
                 8           5        6       0.0+sqrt(-1)*0.25202           0.0           0.932
                 9           4        7       0.0+sqrt(-1)*0.20912           0.0           0.978
                 10          7        8       0.0+sqrt(-1)*0.17615           0.0           1
                 11          4        9       0.0+sqrt(-1)*0.55618           0.0           0.969
                 12          7        9       0.0+sqrt(-1)*0.11001           0.0           1
                 13          9        10      0.03181+sqrt(-1)*0.08450       0.0           1
                 14          6        11      0.09498+sqrt(-1)*0.19890       0.0           1
                 15          6        12      0.12291+sqrt(-1)*0.25581       0.0           1
                 16          6        13      0.06615+sqrt(-1)*0.13027       0.0           1
                 17          9        14      0.12711+sqrt(-1)*0.27038       0.0           1
                 18          10       11      0.08205+sqrt(-1)*0.19207       0.0           1
                 19          12       13      0.22092+sqrt(-1)*0.19988       0.0           1
                 20          13       14      0.17093+sqrt(-1)*0.34802       0.0           1];
 
    t=[8 9 11]';         
nshunt_new = length(shunt_new);      % no of shunt branches

shunt_min = 0.0 ; shunt_max = 0.15 ;     % shunt limits
tap_min = 0.90 ; tap_max = 1.0 ;        % tap ratio limits

                         
nt = length(t) ;                    % no. of tap lines
z=Linedata14(:,4);                	    % line series impedance
y_line14=1./z;
B2=Linedata14(:,5);                	    % half line charging admittances
B=1i*B2;
g=real(z);

from_bus = Linedata14(:,2);
to_bus = Linedata14(:,3);
Qmin = busdata14(:,6);                 % Minimum Reactive Power Limit
Qmax = busdata14(:,7);                 % Maximum Reactive Power Limit
type = busdata14(:,5);                 % Type of Bus 1-Slack, 2-PV, 3-PQ
pv = find(type == 2) ;
npv = length(find(type == 2));      % No of pv buses excluding slack bus(type =1).
%-----------------------------------------------------------------------------------------
LB=[-40 0 -6 -6 0.0 0.0 0.0 0.9 0.9 0.9];        %[Q Sh T]
UB=[50 40 24 24 0.15 0.15 0.15 1.0 1.0 1.0];     %[Q Sh T]
nv=length(LB);  %No. of variables
