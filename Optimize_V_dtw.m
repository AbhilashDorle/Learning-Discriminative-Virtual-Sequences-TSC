function virtual_sequence=Optimize_V(virtual_sequence,classnum,trainsetnum,L,trainset,templatenum,B2)

%FUNCTION to learn the Virtual sequence


%Variables to calculate closed forms
B1=0;
vjb=0;
vja=0;

N = sum(trainsetnum);

for clnum=1:classnum
    current_sequence=virtual_sequence{clnum};
    for j=1:templatenum
        B1=0;
        vjb=0;
        vja=0;
         for c = 1:classnum
                for n = 1:trainsetnum(c)
                    seqlen = size(trainset{c}{n},1);
                    %[dist, T] = OPW_w(trainset{c}{n}*L,virtual_sequence{c},[],[],lambda1,lambda2,delta,0);
                    [dist, T] = dtw2((trainset{c}{n}*L)',current_sequence');                   
                    for i = 1:seqlen
                        B1=B1+T(i,j);
                        vja=vja+(T(i,j)*trainset{c}{n}(i,:)*L);
                    end
                end
         end
         for cl=1:classnum
             for n=1:trainsetnum(cl)
                 for c=1:classnum
                     if c~=n
                         for y=1:trainsetnum(c)
                            for i=1:templatenum
                                vjb=vjb+virtual_sequence{c}(i,:);
                            end
                         end
                     end
                 end
             end
         end
         virtual_sequence{clnum}(j,:)=(vja-(N*vjb))/(B1-B2);
    end
end

end