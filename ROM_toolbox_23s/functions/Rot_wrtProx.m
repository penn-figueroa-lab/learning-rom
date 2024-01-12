function rot_local = Rot_wrtProx (quatProx,quatDist)
rotProx = quat2rotm (quatProx);
rotDist = quat2rotm (quatDist);
rot_local = pagemtimes (pageinv(rotProx),rotDist);

% rot_local = pagemtimes (rotDist,pageinv(rotProx));
% rot_local = pagetranspose(rot_local);

% [out, varargout] = isrot(rot_local);
% if ~isrot(rotDist) || anynan(rotDist)
%     rotDist
%     fprintf('ROT matrix error');
%     fprintf('Error type: %s\n',varargout);    
% end

end