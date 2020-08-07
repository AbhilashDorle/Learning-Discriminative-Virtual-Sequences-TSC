function [L,loss]=Optimize_W(L,templatenum,trainsetnum,classnum,lambda,dim,virtual_sequence,trainset,downdim)
R_A = zeros(dim,dim);
R_B = zeros(dim,downdim);
N = sum(trainsetnum);
loss=0;
for c = 1:classnum
        for n = 1:trainsetnum(c)
            seqlen = size(trainset{c}{n},1);
            %[dist, T] = OPW_w(trainset{c}{n}*L,virtual_sequence{c},[],[],lambda1,lambda2,delta,0);
            [dist, T] = dtw2((trainset{c}{n}*L)',virtual_sequence{c}');
            loss = loss + dist;
            for i = 1:seqlen
                temp_ra = trainset{c}{n}(i,:)'*trainset{c}{n}(i,:);
                for j = 1:templatenum
                    R_A = R_A + T(i,j)*temp_ra;
                    R_B = R_B + T(i,j)*trainset{c}{n}(i,:)'*virtual_sequence{c}(j,:);
                end
            end
        end
 end
 
% loss = loss/N + trace(L'*L);
%  if abs(loss - loss_old) < err_limit
%         flag=0;
% %     else
% %         loss_old = loss;
%  end
 
R_I = R_A + lambda*N*eye(dim); 
%L = inv(R_I) * R_B;
L = R_I\R_B;