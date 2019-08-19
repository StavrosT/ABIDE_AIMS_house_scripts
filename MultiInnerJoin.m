function JoinN = MultiInnerJoin(varargin)
JoinN = varargin{1}
for k=2:nargin
    JoinN = innerjoin(JoinN, varargin{k});
end
end
