clear all
 clc
Data_14;
Ybus14;
del= zeros(nbus,1);         
bus = busdata14(:,1);         
V = busdata14(:,2);       
type = busdata14(:,5);        
Psp = (pg-pd);            
P = Psp;
Qsp = (qg-qd);             
Pl = pd;                   
Ql = qd;                   
Qmin = busdata14(:,6);        
Qmax = busdata14(:,7);       
G = real(Y);             
B = imag(Y);             
BMva = 100;               
pv = find(type == 1 | type == 0);   
pq = find(type == 2);              
npv = length(pv);                  
npq = length(pq);                

Tol = 1;  
Iter = 1;
while (Tol >  0.00001)   
    
    P = zeros(nbus,1);
    Q = zeros(nbus,1);
   
    for i = 1:nbus
        for k = 1:nbus
            P(i) = P(i) + V(i)* V(k)*(G(i,k)*cos(del(i)-del(k)) + B(i,k)*sin(del(i)-del(k)));
            Q(i) = Q(i) + V(i)* V(k)*(G(i,k)*sin(del(i)-del(k)) - B(i,k)*cos(del(i)-del(k)));
        end
    end
P;
Q;

    if Iter <=7 && Iter > 2   
        for n = 2:nbus
            if type(n) == 1
                QG = Q(n)+Ql(n);
                if QG < Qmin(n)
                    Qi(n) = Qmin(n)+Ql(n);
                      V(n) = V(n) + 0.01;
                elseif QG > Qmax(n)
                    Qi(n) = Qmax(n)-Ql(n);
                      V(n) = V(n) - 0.01;
                end
            end
         end
   end
  Qitr (:,Iter)=Ql; 
  
    dPa = Psp-P;
    dQa = Qsp-Q;
    k = 1;
    dQ = zeros(npq,1);
    for i = 1:nbus
        if type(i) == 2
            dQ(k,1) = dQa(i);
            k = k+1;
        end
    end
    dP = dPa(2:nbus);
    M = [dP; dQ];   
  % Jacobian
    J1 = zeros(nbus-1,nbus-1);
    for i = 1:(nbus-1)
        m = i+1;
        for k = 1:(nbus-1)
            n = k+1;
            if n == m
                for n = 1:nbus
                    J1(i,k) = J1(i,k) + V(m)* V(n)*(-G(m,n)*sin(del(m)-del(n)) + B(m,n)*cos(del(m)-del(n)));
                end
                J1(i,k) = J1(i,k) - V(m)^2*B(m,m);
            else
                J1(i,k) = V(m)* V(n)*(G(m,n)*sin(del(m)-del(n)) - B(m,n)*cos(del(m)-del(n)));
            end
        end
    end
    
    % J2 - Derivative of Real Power Injections with V..
    J2 = zeros(nbus-1,npq);
    for i = 1:(nbus-1)
        m = i+1;
        for k = 1:npq
            n = pq(k);
            if n == m
                for n = 1:nbus
                    J2(i,k) = J2(i,k) + V(n)*(G(m,n)*cos(del(m)-del(n)) + B(m,n)*sin(del(m)-del(n)));
                end
                J2(i,k) = J2(i,k) + V(m)*G(m,m);
            else
                J2(i,k) = V(m)*(G(m,n)*cos(del(m)-del(n)) + B(m,n)*sin(del(m)-del(n)));
            end
        end
    end
    
    % J3 - Derivative of Reactive Power Injections with Angles..
    J3 = zeros(npq,nbus-1);
    for i = 1:npq
        m = pq(i);
        for k = 1:(nbus-1)
            n = k+1;
            if n == m
                for n = 1:nbus
                    J3(i,k) = J3(i,k) + V(m)* V(n)*(G(m,n)*cos(del(m)-del(n)) + B(m,n)*sin(del(m)-del(n)));
                end
                J3(i,k) = J3(i,k) - V(m)^2*G(m,m);
            else
                J3(i,k) = V(m)* V(n)*(-G(m,n)*cos(del(m)-del(n)) - B(m,n)*sin(del(m)-del(n)));
            end
        end
    end
    
    % J4 - Derivative of Reactive Power Injections with V..
    J4 = zeros(npq,npq);
    for i = 1:npq
        m = pq(i);
        for k = 1:npq
            n = pq(k);
            if n == m
                for n = 1:nbus
                    J4(i,k) = J4(i,k) + V(n)*(G(m,n)*sin(del(m)-del(n)) - B(m,n)*cos(del(m)-del(n)));
                end
                J4(i,k) = J4(i,k) - V(m)*B(m,m);
            else
                J4(i,k) = V(m)*(G(m,n)*sin(del(m)-del(n)) - B(m,n)*cos(del(m)-del(n)));
            end
        end
    end
    
    J = [J1 J2; J3 J4];    
     
    X = J\M;               
    dTh = X(1:nbus-1);     
    dV = X(nbus:end);      

    % Updating State Vectors..
    del(2:nbus) = dTh + del(2:nbus);  
    k = 1;
    for i = 2:nbus
        if type(i) == 2

            V(i) = dV(k) + V(i);      
            k = k+1;
        end
    end
    
    Iter = Iter + 1;
    Tol = max(abs(M));                 
    
end
[P Q];
Iter_new=Iter-1;
Voltage=zeros(nbus,1);

for i=1:nbus
    [w,l]=pol2cart(del(i),V(i));
    Voltage(i)=w+1i*l;
end
Del_new=(180/pi)*del;

Voltage_delta=[V,Del_new]

Vi=V(from_bus);
Vj=V(to_bus);
del_i=Del_new(from_bus);
del_j=Del_new(to_bus);
g=real(y_line14);
Total_Power_Loss=0;

for k=1:20   
Power_Loss(k)=g(k)*[((Vi(k)^2)+(Vj(k)^2)-(2*Vi(k)*Vj(k)*cosd(del_i(k)-del_j(k))))];
Total_Power_Loss= Total_Power_Loss + Power_Loss(k);
end
Total_Power_Loss
