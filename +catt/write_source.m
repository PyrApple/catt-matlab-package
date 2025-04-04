function [] = write_source(filepath, src)

% write_source write source data to a .loc catt file
% 
% [] = write_source(filepath, rcv)
%
% filepath is a string.
% src is a structure as that generated by the read_source function

% open file
fid = fopen(filepath, 'w');

% file header
fprintf(fid, ';File automatically generated from Matlab script\r\n');
fprintf(fid, '\r\n');

% loop over receivers
for iSrc = 1:length(src)
    
    % init locals
    s = src(iSrc);

    % write id
    line = sprintf('SOURCE %s\r\n', s.idStr);
    fprintf(fid, line);

    % write directivity
    fprintf(fid, ' DIRECTIVITY = "omni"\r\n');

    % write pos
    line = sprintf(' POS = %.2f %.2f %.2f\r\n', s.xyz);
    fprintf(fid, line);

    % write orientation
    if( ~all( isnan(s.aimpos) ) )
        fprintf(fid, ' AIMPOS = %.2f %.2f %.2f\r\n', s.aimpos);
    end

    % write orientation
    if( ~all( isnan(s.aimangles) ) )
        fprintf(fid, ' AIMANGLES = %.2f %.2f\r\n', s.aimangles);
    end

    % write power
    fprintf(fid, ' Lp1m_a = <100 100 100 100 100 100 : 100 100>\r\n');
    
    % end
    fprintf(fid, 'END\r\n');
    fprintf(fid, '\r\n');
        
end

% close file
fclose(fid);

end