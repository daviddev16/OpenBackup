unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Mask,
  System.IOUtils,
  Vcl.ExtCtrls,
  System.Types,
  FileCtrl;

type
  EPathNotFoundException = class(Exception);

  TMainForm = class(TForm)
    LstOrigins: TListBox;
    ProgressBar: TProgressBar;
    BtnStart: TButton;
    EdtDestination: TLabeledEdit;
    LblOrigin: TLabel;
    MmStatus: TMemo;
    LblPercent: TLabel;
    BtnRemove: TButton;
    BtnAdd: TButton;
    OpenFolderDialog: TOpenDialog;
    LblIdentifier: TLabeledEdit;
    procedure BtnStartClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnRemoveClick(Sender: TObject);

  private

    FilesCount : Integer;
    FilesDoneCopied : Integer;
    PercentBuilder : TStringBuilder;

    function CalculateFilesCount(SourceFolder : String) : Integer;
    function CreateInstantBackupFolderName() : String;

    procedure CopyFolder(SourceFolder, DestinationFolder : String);
    procedure UpdateUIStatus(SourceFile, DestinationFile : String);
    procedure ClearAllUIElements();

  public

    constructor Create(AOwner: TComponent); override;

  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited;
  PercentBuilder := TStringBuilder.Create;
end;

procedure TMainForm.BtnAddClick(Sender: TObject);
var
  FolderPath : String;
begin
  SelectDirectory('Selecione uma pasta', '', FolderPath);
  if Not String.IsNullOrWhiteSpace(FolderPath) then
  begin
    LstOrigins.Items.Add(FolderPath);
  end;

end;

procedure TMainForm.BtnRemoveClick(Sender: TObject);
begin

  if LstOrigins.ItemIndex <> -1 then
  begin
    LstOrigins.Items.Delete(LstOrigins.ItemIndex);
  end;

end;

procedure TMainForm.BtnStartClick(Sender: TObject);
var
  SourceFolders     : TStrings;
  BackupDestFolder  : String;
  DestinationFolder : String;
begin

  SourceFolders := LstOrigins.Items;

  DestinationFolder := EdtDestination.Text;
  BackupDestFolder  := TPath.Combine(DestinationFolder, CreateInstantBackupFolderName);

  if Not TDirectory.Exists(BackupDestFolder) then
    TDirectory.CreateDirectory(BackupDestFolder);

  for var Folder in SourceFolders do
  begin
    FilesCount := FilesCount + CalculateFilesCount(Folder);
  end;

  ProgressBar.Max := FilesCount;
  ProgressBar.Min := 0;

  TThread.CreateAnonymousThread(
  procedure
  begin
    for var Folder in SourceFolders do
    begin
      CopyFolder(Folder, TPath.Combine(BackupDestFolder,
        ExtractFileName(ExcludeTrailingBackslash(Folder))));
    end;
    ClearAllUIElements;
  end
  ).Start;


end;

function TMainForm.CalculateFilesCount(SourceFolder : String) : Integer;
var
  Counter : Integer;
begin

  if not TDirectory.Exists(SourceFolder) then
    raise EPathNotFoundException.Create('A pasta de origem não existe! Verifique.');

  Counter := 0;
  for var CurrentFile in TDirectory.GetFiles(SourceFolder) do
    Inc(Counter);

  for var CurrentDir in TDirectory.GetDirectories(SourceFolder) do
  begin
    Counter := Counter + CalculateFilesCount(CurrentDir);
  end;

  Result := Counter;

end;


procedure TMainForm.CopyFolder(SourceFolder, DestinationFolder: String);
var
  SourceFiles : TStringDynArray;
  SourceFile  : String;
  DestFile    : String;
  DestFolder  : String;
begin
  SourceFiles := TDirectory.GetFiles(SourceFolder);

  if not TDirectory.Exists(DestinationFolder) then
    TDirectory.CreateDirectory(DestinationFolder);

  for SourceFile in SourceFiles do
  begin
    DestFile := TPath.Combine(DestinationFolder, TPath.GetFileName(SourceFile));
    UpdateUIStatus(SourceFile, DestFile);
    TFile.Copy(SourceFile, DestFile, True);
    Inc(FilesDoneCopied);
  end;

  for var SubDirectory in TDirectory.GetDirectories(SourceFolder) do
  begin
    var DestSubDirectory := TPath.Combine(DestinationFolder, TPath.GetFileName(SubDirectory));
    CopyFolder(SubDirectory, DestSubDirectory);
  end;

end;

procedure TMainForm.UpdateUIStatus(SourceFile, DestinationFile : String);
begin

  PercentBuilder.Clear;
  MmStatus.Clear;

  with (PercentBuilder) do
  begin
    Append(IntToStr(FilesDoneCopied));
    Append('/');
    Append(IntToStr(FilesCount));
    Append(' ');
    Append(FloatToStr( (FilesDoneCopied / FilesCount) * 100) );
    Append(' %');
  end;

  LblPercent.Caption := PercentBuilder.ToString;
  ProgressBar.Position := FilesDoneCopied;

  MmStatus.Lines.Add('Copiando:');
  MmStatus.Lines.Add('Origem: ' + SourceFile);
  MmStatus.Lines.Add('Destino: ' + DestinationFile);

  Application.ProcessMessages;

end;

procedure TMainForm.ClearAllUIElements();
begin
  MmStatus.Clear;
  PercentBuilder.Clear;
  LblPercent.Caption := '0/0';
  ProgressBar.Position := 0;
end;

function TMainForm.CreateInstantBackupFolderName() : String;
var
  DateStr : String;
begin
  DateStr := FormatDateTime('yyyy-mm-dd_(hh)(nn)(ss)', Now);
  Result := LblIdentifier.Text + '_' + DateStr;
end;


end.
