function [img_plus,img_minus] = get_calib_image_from_event(event_file)
    file = load(event_file);
    idx = sub2ind([128,128],file(20:end,2)+1,file(20:end,3)+1);
    val = file(20:end,4);
    plus_idx = val==1;
    minus_idx = val==-1;
    img_plus = accumarray(idx(plus_idx),1,[128*128,1]);
    img_plus = reshape(img_plus,[128,128]);
    img_minus = accumarray(idx(minus_idx),1,[128*128,1]);
    img_minus = reshape(img_minus,[128,128]);
end