function [SINRofETs, worstSINR, fairness] = SINR_ETs_cellReSelection(B, n, Gtilde, nET, TVpower, delta)
    
    inf_ET_SU = Gtilde(1:n*nET, n*nET+1:n*nET+n).*(ones(n*nET,1)*sum(B, 2)'); % n*nET x n, the power received from every SU
    [V, I] = max(inf_ET_SU'); % I stores the indices of the PU for each ET, which transmits the biggest power to that ET. cell selection!
    F = (B* B' ~= 0); % n x n, relationship between SUs
    F = F - eye(size(B, 1));
    F_ET = [];
    for i=1: n*nET
        F_ET(i,:) = F(I(i) ,:);
    end % F_ET tells each ET, after selecting cell, what is the interference on the channels which are the same with the selected cell
    inf_ET_SU = inf_ET_SU.* F_ET; % bad interference
    
    SINRofETs = 10*log10(V./(sum(inf_ET_SU, 2)'+ delta));
%     SINRofETs = V./(sum(inf_ET_SU, 2)'+delta);

    
    
    SINRofETs = sort(SINRofETs);
    worstSINR = mean(SINRofETs(1:size(SINRofETs,2)/5));
    
    
    
    count = [];
    for i=1: n %  tranverse n WBSs
       xx = I;
       xx(xx~=i) = [];
       count(i) = size(xx, 2);
    end
   
    fairness= std(count);
    