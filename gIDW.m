
function Vi = gIDW(Xc,Yc,Vc,Xi,Yi,w)

% initialize output
    length=size(Xi,1);
    width=size(Xi,2);
   
    Vi = zeros(size(Xi,1),size(Xi,2));
    for i=1:width
       
        D = sqrt((Xi(i)-Xc)^2 +(Yi(i)-Yc)^2);
       

        if D==0
            Vi(i) = Vc;
        else
            Vi(i) =  Vc*(D^w) ;
            %Vi(i)
        end
       
    end
   

return