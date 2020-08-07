function [Acc,knn_averagetime] = NNClassifier_dtw(classnum,trainset,trainsetnum,testsetdata,testsetdatanum,testsetlabel,options)
    
    trainsetdatanum = sum(trainsetnum);
    trainsetdata = cell(1,trainsetdatanum);
    trainsetlabel = zeros(trainsetdatanum,1);
    sample_count = 0;
    for c = 1:classnum
        for per_sample_count = 1:trainsetnum(c)
            sample_count = sample_count + 1;
            trainsetdata{sample_count} = trainset{c}{per_sample_count};
            trainsetlabel(sample_count) = c;
        end
    end
    
    testsetlabelori = testsetlabel;
    testsetlabel = getLabel(testsetlabelori);
    trainsetlabelfull = getLabel(trainsetlabel);

    %Number of nearest neigbor to consider
    k_pool = [1];
    
    k_num = size(k_pool,2);
    
    Acc = zeros(k_num,1);
    tic;
    dis_totrain_scores = zeros(trainsetdatanum,testsetdatanum);
    ClassLabel = [1:classnum]';
    dis_ap = zeros(1,testsetdatanum);
    
    rightnum = zeros(k_num,1);
    for j = 1:testsetdatanum       
        for m2 = 1:trainsetdatanum
            [Dist,T] = dtw2(trainsetdata{m2}',testsetdata{j}');
            if isnan(Dist)
                disp('NaN distance!');
            end
            dis_totrain_scores(m2,j) = Dist;
        end
        
        [distm,index]=sort(dis_totrain_scores(:,j));
        
        for k_count = 1:k_num
            cnt=zeros(classnum,1);
            for temp_i = 1:k_pool(k_count)
                ind=find(ClassLabel==trainsetlabel(index(temp_i)));
                cnt(ind)=cnt(ind)+1;
            end
            [distm2,ind]=max(cnt);        
            predict=ClassLabel(ind);
            predict = predict(1);
            if predict==testsetlabelori(j)
                rightnum(k_count) = rightnum(k_count) + 1;
            end
        end              
        
        temp_dis = -dis_totrain_scores(:,j);
        temp_dis(find(isnan(temp_dis))) = 0;

    end
    Acc = rightnum./testsetdatanum;    
    
    knn_time = toc;
    knn_averagetime = knn_time/testsetdatanum;
end

function [X] = getLabel(classid)
    X = zeros(numel(classid),max(classid))-1;
    for i = 1 : max(classid)
        indx = find(classid == i);
        X(indx,i) = 1;
    end
end