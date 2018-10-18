function gifPlayerGUI(fname,handles)
    %# read all GIF frames
    info = imfinfo(fname, 'gif');
    delay = ( info(1).DelayTime ) / 100;
    [img,map] = imread(fname, 'gif', 'frames','all');
    [imgH,imgW,~,numFrames] = size(img);
axes(handles.axes3)
    %# prepare GUI, and show first frame
%      hFig = figure('Menubar','none', 'Resize','off', ...
%          'Units','pixels', 'Position',[300 300 imgW imgH]);
%     movegui((handles.axes3),'center')
%     movegui(hFig,'center')
    hAx = (handles.axes3);
%     hAx = axes('Parent',hFig, ...
%         'Units','pixels', 'Position',[1 1 imgW imgH]);
    %axes(handles.axes3)
    hImg = imshow(img(:,:,:,1), map, 'Parent',hAx);
    pause(delay)

    %# loop over frames continuously
    counter = 1;
    rounds = 0;
    while ishandle(hImg) && rounds < 5
        %# increment counter circularly
        counter = rem(counter, numFrames) + 1;
        if counter == 15
            rounds = rounds+1;
        end
        %# update frame
        set(hImg, 'CData',img(:,:,:,counter))
        %# update colormap
        n = max(max( img(:,:,:,counter) ));
        colormap( info(counter).ColorTable(1:n,:) )

        %# pause for the specified delay
        pause(delay)
    end
end