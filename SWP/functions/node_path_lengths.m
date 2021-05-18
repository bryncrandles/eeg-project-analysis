function L_i = node_path_lengths(A)

% Code from avg_path_matrix.m written by Eric Bridgeford (Reference: Muldoon, Bridgeford, and 
% Bassett (2015) "Small-World Propensity in Weighted, 
% Real-World Networks" http://arxiv.org/abs/1505.02194)
% Also uses the graphallshortestpaths function which is from the
% bioinformatics toolbox.

n = length(A);
M = sparse(A);
D = graphallshortestpaths(M, 'directed', 'false');

%checks if a node is disconnected from the system, and replaces
%its value with 0
for i = 1:n
    for j = 1:n
        if isinf(D(i,j))
            D(i,j) = 0;
        end
    end
end

L_i = mean(D);

end