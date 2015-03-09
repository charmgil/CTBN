function d = distance(x1, x2, mode)

if ~strcmp(class(mode),'char')
    fprintf( 2, 'err: arg3 should be a string.\n\n' );
    return;
end

if strcmp(mode,'euclidean')
    d = norm(x1 - x2);
else
    fprintf( 2, 'err: unknown distance metric.\n\n' );
    return;
end



end %end of function dist()