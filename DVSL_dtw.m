function L_new = DVSL_dtw(trainset,templatenum,lambda,options,old_virtseq,gamma,num)

%Variables used for the optimization and intialization 
max_nIter = options.max_iters;
err_limit = options.err_limit;
classnum = length(trainset);
downdim = classnum*templatenum;
dim = size(trainset{1}{1},2);

trainsetnum = zeros(1,classnum);

%Variable used to store the learnt virtual sequence
new_virtseq = cell(1,classnum);

for c = 1:classnum
    trainsetnum(c) = length(trainset{c});
end


%% inilization
R_A = zeros(dim,dim);
R_B = zeros(dim,downdim);
N = sum(trainsetnum);
for c = 1:classnum
    for n = 1:trainsetnum(c)
        seqlen = size(trainset{c}{n},1);
        T_ini = ones(seqlen,templatenum)./(seqlen*templatenum);
        for i = 1:seqlen
            temp_ra = trainset{c}{n}(i,:)'*trainset{c}{n}(i,:);
            for j = 1:templatenum
                R_A = R_A + T_ini(i,j)*temp_ra;
                R_B = R_B + T_ini(i,j)*trainset{c}{n}(i,:)'*old_virtseq{c}(j,:);
            end
        end
    end
end

%Closedform varaibles, A^(-1) in the text
R_I = R_A + lambda*N*eye(dim); 
L_old = R_I\R_B;

%Closedform variables, C in the text
B2=0;
for cl=1:classnum
   for n=1:trainsetnum(cl)
       for c=1:classnum
          if c~=cl
              for y=1:trainsetnum(c)
                for i=1:templatenum
                    B2=B2+1 ;
                end
              end
          end
       end
   end
end
B2=(sum(trainsetnum))*B2;

%% update
loss_old = 10^8;

u=0;%iteration number
l=[];%array for storing loss

for nIter = 1:max_nIter
    u=u+1;
    loss = 0;
    R_A = zeros(dim,dim);
    R_B = zeros(dim,downdim);
    N = sum(trainsetnum);
    
    for c = 1:classnum
        for n = 1:trainsetnum(c)
            seqlen = size(trainset{c}{n},1);

            [dist, T] = dtw2((trainset{c}{n}*L_old)',old_virtseq{c}');
            loss = loss + dist;
            
            for i = 1:seqlen
                temp_ra = trainset{c}{n}(i,:)'*trainset{c}{n}(i,:);
                for j = 1:templatenum
                    R_A = R_A + T(i,j)*temp_ra;
                    R_B = R_B + T(i,j)*trainset{c}{n}(i,:)'*old_virtseq{c}(j,:);
                end
            end
        end
    end

    loss = loss/N + trace(L_old'*L_old);
    fprintf('Iteration %d loss:%f\n',nIter,loss);
    fprintf('\n');
    fprintf('difference: %f\n',abs(loss - loss_old));
    fprintf('\n');
    l(u)=loss;

    if abs(loss - loss_old) < err_limit
        break;
    else
        loss_old = loss;
    end
    
    R_I = R_A + lambda*N*eye(dim); 
    L_temp = R_I\R_B;
    L_new=L_old-(gamma*(L_temp));
    L_old=L_new;

    temp_virt=Optimize_V_dtw(old_virtseq,classnum,trainsetnum,L_new,trainset,templatenum,B2);
    for c=1:classnum
       new_virtseq{c}=old_virtseq{c}-(gamma*temp_virt{c});
    end

    old_virtseq=new_virtseq;
    
end

% Saving the convergence curve
x=1:u;
fig=plot(x,l);
saveas(fig,strcat((num2str(num)),'-',(num2str(lambda)),'-',(num2str(gamma)),'.png'));


end
