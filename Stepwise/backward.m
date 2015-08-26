function [Inew]=backward(I,parameter1,parameter2,D,csem)

%% This procedure is 'backeward' tcc selection of linking items
%  Input I is the index of linking items we alredy selected
%  Input R is the index of remaining linking items we haven't selected
%  Output I is the index of updated selected linking items
%  Output R is the index of updated remaining linking items

n=size(parameter1,1);
R=setdiff(1:n,I);

%orginal tccdiff
tccdiff0=areadiff(parameter1(I,:),parameter2(I,:),D);

diff=zeros(length(R),1);

%% Find potential item that could be removed
if ~isempty(I)
    diff=zeros(length(I),1);
    %  Find out one item in the linking set with samllest area difference
    for m=1:length(I)
        II=setdiff(I,I(m));
        diff(m)=areadiff(parameter1(II,:),parameter2(II,:),D);
    end
    [~,index]=sort(diff);
    proposal_item_no=I(index(1));
    
    %  Update I 
    Ipro=setdiff(1:n,[R proposal_item_no]);
    %  Compute TCC difference with updated linking set
    tccdiff1=diff(index(1));
    if (tccdiff1<tccdiff0)
        if (abs(tccdiff0-tccdiff1)>csem)
        I=Ipro;
        end
    end
end

%update I
Inew=I;
Inew=sort(Inew);