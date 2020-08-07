function [testingsetdata,testingsetdatalabel,testingsetdatanum]=test
data=load("/home/dorle/Dr_Sheng_Li/Datasets/UCRArchive_2018/Beef/Beef_TEST.csv");
testinglabel=data(:,1);
testingset=data(:,2:end);

testingsetdata=cell([1,size(data,1)]);
for i =1:length(testinglabel)
    testingsetdata{1,i}=testingset(i,:);
end
testingsetdatalabel=[];
for i = 1:1:size(testinglabel,1)
    testingsetdatalabel(i)=testinglabel(i);
end
testingsetdatanum=size(data,1);

end

