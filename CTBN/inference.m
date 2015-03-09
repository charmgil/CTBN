function [prob, vars] = inference(T, target_vars)

global is_verbose;
is_verbose = true;

% PREP: examine tree T to find which target nodes are in the same tree
% collect all nodes wo/ parent
counter = 0;
for i = 1:length(T)
    if isempty( T{i}.parent )
        counter = counter + 1;
        root_i(counter) = i;
    end
end

% group target variables by their membership (to root)
members = cell( 1, length(root_i) );
for i = 1:length(root_i)
    % collect tree members by tree traversal
    members{i} = collect_members(T, root_i(i));
end

% exclude the trees without target_vars
counter = 0;
for i = 1:length(root_i)
    targets_in_tree_i = intersect( members{i}, target_vars );
    
    if ~isempty(targets_in_tree_i)
        counter = counter + 1;
        new_root_i(counter) = root_i(i);
        new_members{counter} = members{i};
    end
end
root_i = new_root_i;
members = new_members;

% init prob
prob = cell( 1, length(root_i) );
%fprintf( 2, 'DEBUG: #trees in T = %d\n', length(root_i) );

% PROC
for i = 1:length(members)
    targets_in_tree_i = intersect( members{i}, target_vars );
    
    if isempty( T{root_i(i)}.children )
        prob{i} = exp(T{root_i(i)}.log_potential)';
        vars{i} = T{root_i(i)}.node;
    else
        % clique tree
        [ Tc, Tc_adjmat ] = convert_to_clique_tree( T, root_i(i) );

        % message calib
        for j = 1:length(Tc)
            tmp = intersect( Tc{j}.var, target_vars );
            if ~isempty(tmp)
                root_on_Tc = j;
                break;
            end
        end

        msg = message_calib_joint( Tc, Tc_adjmat, targets_in_tree_i, root_on_Tc );

        % compute the marginal
        [ prob{i}, vars{i} ] = compute_joint( targets_in_tree_i, Tc, msg, root_on_Tc );
    end
end


% combine prob{i}
tmp_prob = 1;
for i = length(prob):-1:1
    tmp = [];
    for j = 1:length(prob{i})
        tmp = [ tmp; prob{i}(j) * tmp_prob ];
    end
    tmp_prob = tmp;
end

% combine vars{i}
tmp_vars = [];
for i = 1:length(vars)
    tmp_vars = [tmp_vars vars{i}];
end

prob = tmp_prob;
vars = tmp_vars;

end%end of joint_inference()


%%
% target = variable to estimate; variable of interest
function [prob, vars] = compute_joint( targets, Tc, msg, root_i )

global is_verbose;

prob = 0;

if is_verbose
    fprintf( '\n====\n' );
end

% estimate joint on root_i
i = root_i;
%for i = root_i:root_i
    if ~isempty( intersect(Tc{i}.var, targets) )
        temp_var = Tc{i}.var;
        temp_potential = Tc{i}.potential;
        
        % combine local CPT and all incoming messages
        for j = 1:length(Tc)
            if ~isempty( msg{j,i} )
                if length( msg{j,i}.var ) == 1
                    if msg{j,i}.var == Tc{i}.var(1)
                        % catesian prod
                        temp_potential(1) = temp_potential(1) * msg{j,i}.potential(1);
                        temp_potential(2) = temp_potential(2) * msg{j,i}.potential(1);
                        temp_potential(3) = temp_potential(3) * msg{j,i}.potential(2);
                        temp_potential(4) = temp_potential(4) * msg{j,i}.potential(2);

                    elseif msg{j,i}.var == Tc{i}.var(2)
                        % catesian prod
                        temp_potential(1) = temp_potential(1) * msg{j,i}.potential(1);
                        temp_potential(3) = temp_potential(3) * msg{j,i}.potential(1);
                        temp_potential(2) = temp_potential(2) * msg{j,i}.potential(2);
                        temp_potential(4) = temp_potential(4) * msg{j,i}.potential(2);
                    end

                else
                    % collect variables
                    for k = 2:length(msg{j,i}.var)
                        if msg{j,i}.var(k) == Tc{i}.var(1) ...      % DEBUG PURPOSE
                                || msg{j,i}.var(k) == Tc{i}.var(2)
                            fprintf( 2, 'err: critical error @htnt\n' ); % DEBUG PURPOSE
                        end                                         % DEBUG PURPOSE

                        temp_var = [ temp_var msg{j,i}.var(k) ];
                    end

                    % catesian prod
                    if msg{j,i}.var(1) == Tc{i}.var(1)
                        shared_var = 1;
                    elseif msg{j,i}.var(1) == Tc{i}.var(2)
                        shared_var = 2;
                    else                                        % DEBUG PURPOSE
                        fprintf( 2, 'err: critical error @wgth\n' ); % DEBUG PURPOSE
                    end

                    LEN = length(temp_var);
                    for k = 0:2^LEN-1
                        assignment = zeros( 1, LEN );
                        for l = 1:LEN
                            assignment(l) = floor( mod(k,2^(LEN-l+1))/2^(LEN-l) );
                        end

                        % filling CPT
                        local_cpt_i = 1 + bin2dec( num2str([assignment(1) assignment(2)]) );
                        msg_cpt_i = 1 + bin2dec( strrep( num2str([assignment(shared_var) assignment(3:end)]), ' ', '' ) );

                        temp(k+1) = temp_potential(local_cpt_i) * msg{j,i}.potential(msg_cpt_i);
                    end
                    temp_potential = temp';
                    
                end
            end
        end
        
        % marginalize on targets
        j = 1;
        while j <= length(temp_var)
            if isempty( intersect(temp_var(j), targets) )
                temp_var = temp_var([1:(j-1) (j+1):end]);
                LEN = length(temp_var);
                temp = [];
                
                for k = 0:2^LEN-1
                    assignment = zeros( 1, LEN );
                    for l = 1:LEN
                        assignment(l) = floor( mod(k,2^(LEN-l+1))/2^(LEN-l) );
                    end
                    p0_i = 1 + bin2dec( strrep( num2str([assignment(1:(j-1)) 0 assignment(j:end)]), ' ', '' ) );
                    p1_i = 1 + bin2dec( strrep( num2str([assignment(1:(j-1)) 1 assignment(j:end)]), ' ', '' ) );

                    temp(k+1) = temp_potential(p0_i) + temp_potential(p1_i);
                end
                temp_potential = temp';
            else
                j = j + 1;
            end
        end
        
        % return values
        vars = temp_var;
        prob = temp_potential;
        return;
    end
%end

end%end of compute_joint()


%%
% Tc = Nodes for a clique tree
% Tc_adjmat = Adjacency matrix for Tc
function msg = message_calib_joint( Tc, Tc_adjmat, target_vars, root_on_Tc )

global is_verbose;

NULL = 0;

%root = 1;   % root has to be 1
root = root_on_Tc;

if is_verbose
    fprintf( '----\n' );
end

%post-order traverse
VISITED = false( 1, length(Tc) );

%init a stack
stack = cell( 1, length(Tc) );

%push root
stack_head = 1;
stack{stack_head}.node = root;
stack{stack_head}.from = NULL;  % branched "from"
%mark
VISITED(root) = true;
%msg store
msg = cell( length(Tc) );

% messages from children to parents
while stack_head ~= 0
    %pop
    i = stack{stack_head}.node;
    from = stack{stack_head}.from;  % branched "from"
    stack_head = stack_head - 1;
    
    %scan neighbors
    if ~isempty(Tc_adjmat)
        neighbors = find(~VISITED & Tc_adjmat(i,:));
    else
        neighbors = [];
    end
    
    if ~isempty(neighbors)
        %push self
        stack_head = stack_head + 1;
        stack{stack_head}.node = i;
        stack{stack_head}.from = from;  % branched "from"
        
        for j = 1:length(neighbors)
            %push neighbors
            stack_head = stack_head + 1;
            stack{stack_head}.node = neighbors(j);
            stack{stack_head}.from = i;
            %mark
            VISITED(neighbors(j)) = true;
        end
    else
        if is_verbose
            fprintf( 'msg: %d->%d', i, from );
        end
        % identify what to eliminate (error catching purpose)
        if from ~= 0   % except on root (of clique tree)
                        
            % compute msg = combine all incoming msg + local CPT
            % msg{i,from} = next_message_upward( i, from, Tc, msg );
            
            temp_potential = Tc{i}.potential;
            temp_var = Tc{i}.var;
            for j = 1:length(Tc)
                if ~isempty( msg{j,i} )
                    if length( msg{j,i}.var ) == 1
                        if is_verbose
                            fprintf('(sz(m)==1)');
                        end
                        if msg{j,i}.var == Tc{i}.var(1)
                            % catesian prod
                            temp_potential(1) = temp_potential(1) * msg{j,i}.potential(1);
                            temp_potential(2) = temp_potential(2) * msg{j,i}.potential(1);
                            temp_potential(3) = temp_potential(3) * msg{j,i}.potential(2);
                            temp_potential(4) = temp_potential(4) * msg{j,i}.potential(2);

                        elseif msg{j,i}.var == Tc{i}.var(2)
                            % catesian prod
                            temp_potential(1) = temp_potential(1) * msg{j,i}.potential(1);
                            temp_potential(3) = temp_potential(3) * msg{j,i}.potential(1);
                            temp_potential(2) = temp_potential(2) * msg{j,i}.potential(2);
                            temp_potential(4) = temp_potential(4) * msg{j,i}.potential(2);
                        end
                        
                    else
                        if is_verbose
                            fprintf('(sz(m)>1)');
                        end
                        % collect variables
                        for k = 2:length(msg{j,i}.var)
                            if msg{j,i}.var(k) == Tc{i}.var(1) ...      % DEBUG PURPOSE
                                    || msg{j,i}.var(k) == Tc{i}.var(2)
                                fprintf( 2, 'err: critical error @qmfi\n' ); % DEBUG PURPOSE
                            end                                         % DEBUG PURPOSE
                            
                            temp_var = [ temp_var msg{j,i}.var(k) ];
                        end
                        
                        % catesian prod
                        if msg{j,i}.var(1) == Tc{i}.var(1)
                            shared_var = 1;
                        elseif msg{j,i}.var(1) == Tc{i}.var(2)
                            shared_var = 2;
                        else                                        % DEBUG PURPOSE
                            fprintf( 2, 'err: critical error @rpxe\n' ); % DEBUG PURPOSE
                        end
                        
                        LEN = length(temp_var);
                        for k = 0:2^LEN-1
                            assignment = zeros( 1, LEN );
                            for l = 1:LEN
                                assignment(l) = floor( mod(k,2^(LEN-l+1))/2^(LEN-l) );
                            end
                            
                            % filling CPT
                            local_cpt_i = 1 + bin2dec( num2str([assignment(1) assignment(2)]) );
                            msg_cpt_i = 1 + bin2dec( strrep( num2str([assignment(shared_var) assignment(3:end)]), ' ', '' ) );
                            
                            temp(k+1) = temp_potential(local_cpt_i) * msg{j,i}.potential(msg_cpt_i);
                        end
                        temp_potential = temp';
                    end
                end
            end
            
            % prep msg to the next clique
            [ ~, xx_i ] = intersect( temp_var, Tc{from}.var );
            [ ~, xxxx_i  ] = intersect( temp_var, target_vars );
            
            % when the parent var of Tc{i} IS NOT shared and NOT in target_vars: parent var can be marginalized
            if isempty( intersect( xx_i, 1 ) ) && isempty( intersect( xxxx_i, 1 ) )
                % marginalize the parent
                temp_var = temp_var(2:end);
                LEN = length(temp_var);
                temp = [];
                for k = 0:2^LEN-1
                    assignment = zeros( 1, LEN );
                    for l = 1:LEN
                        assignment(l) = floor( mod(k,2^(LEN-l+1))/2^(LEN-l) );
                    end
                    p0_i = 1 + bin2dec( strrep( num2str([0 assignment]), ' ', '' ) );
                    p1_i = 1 + bin2dec( strrep( num2str([1 assignment]), ' ', '' ) );
                    
                    temp(k+1) = temp_potential(p0_i) + temp_potential(p1_i);
                end
                temp_potential = temp';
                
            % when the child var of Tc{i} IS NOT in target_vars: child var can be marginalized
            elseif isempty( intersect( xx_i, 2 ) ) && isempty( intersect( xxxx_i, 2 ) )
                % marginalize the child
                temp_var = temp_var([1 3:end]);
                LEN = length(temp_var);
                temp = [];
                for k = 0:2^LEN-1
                    assignment = zeros( 1, LEN );
                    for l = 1:LEN
                        assignment(l) = floor( mod(k,2^(LEN-l+1))/2^(LEN-l) );
                    end
                    p0_i = 1 + bin2dec( strrep( num2str([assignment(1) 0 assignment(2:end)]), ' ', '' ) );
                    p1_i = 1 + bin2dec( strrep( num2str([assignment(1) 1 assignment(2:end)]), ' ', '' ) );
                    
                    temp(k+1) = temp_potential(p0_i) + temp_potential(p1_i);
                end
                temp_potential = temp';
                
            % when the child var of Tc{i} IS in target_vars:
            else
                % DO NOTHING - send the msg (cpt) as is
                %fprintf( 'heads-up: possible logic error @qpeo\n' ); % DEBUG PURPOSE
            end
            if is_verbose
                fprintf( ' ... msg: d(' );
                fprintf( '%d,', temp_var );
                fprintf( '\b) = [ ' );
                fprintf( '%.4f ', temp_potential );
                fprintf( ']\n' );
            end
            
            % deposit in msgbox
            msg{i,from}.var = temp_var;
            msg{i,from}.potential = temp_potential;
            %temp_potential
        end
    end
end

end%end of function message_calib()



%%
% T = Trees in list (arbitrary order)
% root = the index of a root node in T
function [Tc, Tc_adjmat] = convert_to_clique_tree( T, root_i )

global is_verbose;

Tc_count = 0;
VISITED = false( 1, length(T) );

queue = cell( 1, length(T) );

%bookkeeping
VISITED(root_i) = true;
%enqueue
queue_head = 1;
queue_tail = 1;
queue{queue_head}.i = root_i;
queue{queue_head}.from = 0;
root = T{root_i}.node;
root_p_ready = false;
Tc_adjmat = [];

while queue_head - queue_tail >= 0
    %dequeue
    i = queue{queue_tail}.i;
    branched_from = queue{queue_tail}.from;
    queue_tail = queue_tail + 1;
    
    %proc
    if is_verbose
        fprintf( 'node: %d', T{i}.node );
    end
    if i ~= root_i
        % add to the new structure (output clique tree)
        Tc_count = Tc_count + 1;
        Tc{Tc_count}.var(1) = T{i}.parent;
        Tc{Tc_count}.var(2) = T{i}.node;
        Tc{Tc_count}.potential = exp(T{i}.log_potential); % using potential
        if is_verbose
            fprintf( ' \t... Tc{%d}.var: %d, %d\n', Tc_count, Tc{Tc_count}.var );
        end
        if root_p_ready && ~root_p_used
            Tc{Tc_count}.potential(1,:) = Tc{Tc_count}.potential(1,:) * root_potential(1);
            Tc{Tc_count}.potential(2,:) = Tc{Tc_count}.potential(2,:) * root_potential(2);
            root_p_used = true;
        end
        % reshape the CPTs
        Tc{Tc_count}.potential = reshape( Tc{Tc_count}.potential', 4, 1 );
        
        % filling the adjacency matrix
        if T{i}.parent == root  % level1
            if Tc_count > 1
                Tc_adjmat(Tc_count-1,Tc_count) = 1;
                Tc_adjmat(Tc_count,Tc_count-1) = 1;
            end
        else    % level*
            Tc_adjmat(branched_from,Tc_count) = 1;
            Tc_adjmat(Tc_count,branched_from) = 1;
        end
    else
        if is_verbose
            fprintf( '\b@root\n' );
        end
        root_potential = exp(T{i}.log_potential);
        root_p_used = false;
        root_p_ready = true;
    end
    
    %bfs
    if ~isempty( T{i}.children )
        for j = 1:length( T{i}.children )
            child = T{i}.children(j);
            
            for l = 1:length(T)
                if T{l}.node == child && ~VISITED(l)
                    child_i = l;
                    %bookkeeping
                    VISITED(child_i) = true;
                    %enqueue
                    queue_head = queue_head + 1;
                    queue{queue_head}.i = child_i;
                    %record branch point
                    queue{queue_head}.from = Tc_count;
                    break;
                end
            end
        end
    end
end%end of while

end%end of function convert_to_clique_tree()




%% Collect all nodes thru DFS (pre-order traverse)
%
function members = collect_members( T, root_i )

NULL = 0;

% init a stack
stack = zeros( 1, length(T) );
stack_head = 0;

% init
members = [];
i = root_i;

% proc
while stack_head ~= 0 || i ~= NULL
    if i ~= NULL
        % visit
        members = [ members T{i}.node ];
        
        % expand
        if ~isempty( T{i}.children )
            for j = 2:length( T{i}.children )
                stack_head = stack_head + 1;
                stack(stack_head) = lookup( T, T{i}.children(j) );
            end
            i = lookup( T, T{i}.children(1) );
        else
            i = NULL;
        end
    else
        i = stack(stack_head);
        stack_head = stack_head - 1;
    end
end

end%end of function collect_members()


%%
function node_i = lookup(T, node)
node_i = 0;

for i = 1:length(T)
    if T{i}.node == node
        node_i = i;
        break;
    end
end

if node_i == 0
    fprintf( 2, 'err: node not found.\n' );
end

end%end of function lookup()

