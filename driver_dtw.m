%Regularization term, tradeoff parameter
lambda=[0.0007];

%Learning rate
gamma=[0.01];

s=rng;

%Number of classes
classnum=2;

%Temporal structures, l_n in text
templatenum=[2];

%error rate
err= 0.1;

%Columns of the virtual sequence
downdim = classnum*templatenum;

%defining virtual sequence
virtual_sequence = cell(1,classnum);
delete *.png;

disp(virtual_sequence{1});

sum=0;

num=0;



for count=1:1%10
    fprintf('COUNT =%d\n',count);

    % rng(s);

    for c = 1:classnum
        virtual_sequence{c} = randn(templatenum,downdim); 
    end

    disp(virtual_sequence{1});
    disp(virtual_sequence{2});
    [lamdarows,lambdacol]=size(lambda);
    [gammarows,gammacols]=size(gamma);
   
    max_dtwscore=0;
    optimal_lambda=0;
    optimal_gamma=0;

    for i = 1:lambdacol
       for j=1:gammacols
           num=num+1;%variable for plotting graphs
           
           dtw_acc=Evaluate_ground_metric(lambda(i),templatenum(1),virtual_sequence,gamma(j),classnum,err,num);
           
           sum=sum+dtw_acc;
           
           fprintf('lambda=%f\n',lambda(i));
           fprintf('gamma =%f\n',gamma(j));
           fprintf('**********************************************************\n');

           if max_dtwscore<dtw_acc
              max_dtwscore=dtw_acc;
              optimal_lambda=lambda(i);
              optimal_gamma=gamma(j);
           end
           
       end
    end

end

fprintf('Max Score=%f\n',max_dtwscore);
fprintf('Optimal lambda=%f\n',optimal_lambda);
fprintf('Optimal gamma =%f\n',optimal_gamma);


disp('average');
disp(sum/10);