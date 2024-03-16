% Programme for Y bus matrix
Data_14                   
nl=length(Linedata14(:,1));        	% No. of lines
fb=Linedata14(:,2);                 % From buses
tb=Linedata14(:,3);               	% To buses
z=Linedata14(:,4);                	% line series impedance
B2=Linedata14(:,5);                	% half line charging admittances
B=sqrt(-1)*B2;
tap=Linedata14(:,6);               	% tap setting value
nbus=max(max(fb),max(tb)) ;    	% no. of buses
   

ys=1./z;                      	% series admittances  
ysh=shunt;                     	% shunt admittance
Y=zeros(nbus,nbus);            	

 % formation of the off diagonal elements 
  for i=1:nl
      m=fb(i); 
      n=tb(i);
      Y(m,n)= Y(m,n)-ys(i)/tap(i);
      Y(n,m)=Y(m,n);    
  end
  
  %formation of diagonal elements
  for j=1:nbus
      for k=1:nl
          if fb(k)==j
              Y(j,j) = Y(j,j) + ys(k)/(tap(k)^2)+ B(k);
          elseif tb(k) == j
              Y(j,j) = Y(j,j) + ys(k)+ B(k);
          end
      end
        Y(j,j) = Y(j,j) + ysh(j);
  end
 
Y;