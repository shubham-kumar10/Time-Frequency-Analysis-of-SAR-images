function [Image, Header, FileName ]= load_gff_1_8b( FileName, PathName )
% function <[>Image<, Header<, FileName>]> = load_gff_1_8b<( FileName )>;
% OR <[>Image<, Header<, FileName>]> = load_gff_1_8b<( 'defaultPath', PathName )>;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% This software is provided as is, with no guarantee,
%% warranty, or other assurance of functionality or
%% correctness for any purpose. Furthermore, users should
%% have no expectation of support from the authors or
%% Sandia National Laboratories. Use at your own risk.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function loads an image written according to the GSAT File
% Format specification [1] into the MATLAB workspace. It optionally
% returns the values from the header in a MATLAB structure.
%
% Inputs:
% FileName (Optional) If the optional file name argument is present,
% it is assumed to point to a valid GSAT file.
% If the argument is not present, the user is prompted to
% select a file using the file open dialog box.
% PathName (Optional) If the command line has two arguments, and
% the first one is the string 'defaultpath' (any case),
% the program interprets the PathName input as the starting
% directory path to use for the file open dialog box.
%
% Outputs:
% Image The array containing the (non-scaled, non-calibrated) image
% pixels from the file.
% Header (Optional) The MATLAB structure containing all fields of 
% the file header.
% FileName (Optional) The full path- and file-name of the file read.
% References:
% 1) Mendelsohn, G. H., et al, "GSAT Image File Format Specification"
% Revision 1-6 (Draft), 02Feb00.
% Author: W. H. Hensley, 2344
% Written: 8Feb2000
% Copyright: 2000 Sandia National Laboratories
% Revisions:
% 27May2000 WHH Added support for input filename.
% Improved error handling and messaging.
% 28Jun2000 DLB Put back in Bill's revision as follows:
% 14Mar2000 WHH Updated to support GFF Draft 1-6 as of 3/14/2000. This
% changed the way that complex mag/phase pixels are stored,
% so that the phase is always first, regardless of "Endian".
% 08Jul2000 WHH Added support for default path input.
% Test History:
% 12Feb2000 WHH Tested against image from RTV Rev A RadarControl tape:
% 19980726.L01L004:VRTVCHECKOUT0:PASS0000:00000.GFF
%======================================================================
% Check for input, and get file:
%======================================================================
if ( nargin >= 2 ),
 [Header, gffName, gffPath, fid] = read_gff_header_1_8b('defaultPath',PathName);
 FileName = [gffPath gffName];
if fid < 1,
if fid == -3,
 errordlg(['Requested file (' gffName ') is NOT in GSAT format!'],'load_gff_1_8b');
elseif fid == -2,
 errordlg(['Requested file (' gffName ') does not exist'],'load_gff_1_8b');
else
 errordlg(['Header could not be read on file ' gffName ', function aborting.'],'load_gff');
 end
 Image = [];
 Header = [];
return
end
elseif ( nargin >= 1 ),
 [Header, gffName, gffPath, fid] = read_gff_header_1_8b(FileName);
if fid < 1,
if fid == -3,
 errordlg(['Requested file (' FileName ') is NOT in GSAT format!'],'load_gff');
elseif fid == -2,
 errordlg(['Requested file (' FileName ') does not exist'],'load_gff');
else
 errordlg(['Header could not be read on file ' FileName ...
', function aborting.'],'load_gff');
end
 Image = [];
 Header = [];
return
end
else
 [Header, gffName, gffPath, fid] = read_gff_header_1_8b;
 FileName = [gffPath gffName];
if fid < 1,
if fid == -3,
 errordlg(['Requested file (' FileName ') is NOT in GSAT format!'],'load_gff');
elseif fid == -2,
 errordlg(['Requested file (' FileName ') does not exist'],'load_gff');
else
 errordlg(['Header could not be read on file ' FileName ...
', function aborting.'],'load_gff');
end
 Image = [];
 Header = [];
 return
end
end
if (Header.RowMajor)
 FirstIndexLength = Header.RgCnt;
 SecondIndexLength = Header.AzCnt;
 Flip = 0;
else
 FirstIndexLength = Header.AzCnt;
 SecondIndexLength = Header.RgCnt;
 Flip = 1;
end
switch Header.ImageType
case 0,
 fprintf('Reading sqrt(magnitude) pixels.\n');
% Take care of RowMajor
if Flip,
 Image = fread(fid,[FirstIndexLength,SecondIndexLength],'uchar').';
else
 Image = fread(fid,[FirstIndexLength,SecondIndexLength],'uchar');
end
case 1,
 fprintf('Reading complex (magnitude, phase) pixels.\n');
if Header.BytesPerPixel == 4 %phase = 2 bytes, same with magnitude
 Image2 = fread(fid,[FirstIndexLength*2,SecondIndexLength],'ushort');
% Convert to MATLAB complex:
% [3/14/00 WHH All "Endian" cases now store phase first, followed
% by magnitude.]
 Image = Image2(2:2:size(Image2,1),:) .*exp(j * Image2(1:2:size(Image2,1),:) * 2*pi/(2^16));
else %BytesPerPixel=8 bytes=64 bits, therefore phase is 4 bytes=32 bits, mag =4 bytes=32 bits
 Image2 = fread(fid,[FirstIndexLength*2,SecondIndexLength],'ulong');
% Convert to MATLAB complex:
% [3/14/00 WHH All "Endian" cases now store phase first, followed
% by magnitude.]
 Image = Image2(2:2:size(Image2,1),:) .*exp(j * Image2(1:2:size(Image2,1),:) * 2*pi/(2^32));
% Take care of RowMajor
end
if Flip,
 Image = Image.';
end
case 2,%Read in real+imag format pixels
 fprintf('Reading complex (real and imaginary) pixels.\n');
 Image2 = fread(fid,[2*FirstIndexLength SecondIndexLength],'float');
 Image = Image2(1:2:size(Image2,1),:)+j*Image2(2:2:size(Image2,1),:);
%Take care of RowMajor
if Flip,
 Image = Image.';
end
otherwise,
 warndlg(['Unknown pixel type: ' num2str(Header.ImageType) '.'],'load_gff');
end %ends the switch statement
fprintf('FID in load_gff was %d.\n',fid);
fclose(fid);
return
