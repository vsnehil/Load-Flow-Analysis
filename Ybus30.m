% Programme for Y bus matrix
Data_30;
nl=length(Linedata30(:,1));        	% No. of lines
from_bus=Linedata30(:,2);                 % From buses
to_bus=Linedata30(:,3);               	% To buses
B2=Linedata30(:,7);                	% half line charging admittances
B=sqrt(-1)*B2;
tap=Linedata30(:,6);               	% tap setting value
nbus=max(max(from_bus),max(to_bus)) ;    	% no. of buses
   

ys=1./z;                      	  % series admittances  
ysh=sqrt(-1)*busdata30(:,9);                  % shunt admittance
Y=zeros(nbus,nbus);            	

 % formation of the off diagonal elements 
  for i=1:nl
      m=from_bus(i); 
      n=to_bus(i);
      Y(m,n)= Y(m,n)-ys(i)/tap(i);
      Y(n,m)=Y(m,n);    
  end
  
  %formation of diagonal elements
  for j=1:nbus
      for k=1:nl
          if from_bus(k)==j
              Y(j,j) = Y(j,j) + ys(k)/(tap(k)^2)+ B(k);
          elseif to_bus(k) == j
              Y(j,j) = Y(j,j) + ys(k)+ B(k);
          end
      end
        Y(j,j) = Y(j,j) + ysh(j);
  end
 
Y;