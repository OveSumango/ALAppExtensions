#if not CLEAN23
#pragma warning disable AL0432
codeunit 31150 "Sync.Dep.Fld-Customer CZL"
{
    Access = Internal;
    Permissions = tabledata "Customer" = rimd;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeInsertEvent', '', false, false)]
    local procedure SyncOnBeforeInsertCustomer(var Rec: Record Customer)
    begin
        SyncDeprecatedFields(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeModifyEvent', '', false, false)]
    local procedure SyncOnBeforeModifyCustomer(var Rec: Record Customer)
    begin
        SyncDeprecatedFields(Rec);
    end;

    local procedure SyncDeprecatedFields(var Rec: Record Customer)
    var
        PreviousRecord: Record Customer;
        SyncDepFldUtilities: Codeunit "Sync.Dep.Fld-Utilities";
        PreviousRecordRef: RecordRef;
        DepFieldTxt, NewFieldTxt : Text;
    begin
        if Rec.IsTemporary() then
            exit;
        if SyncDepFldUtilities.GetPreviousRecord(Rec, PreviousRecordRef) then
            PreviousRecordRef.SetTable(PreviousRecord);
        DepFieldTxt := Rec."Registration No. CZL";
        NewFieldTxt := Rec."Registration Number";
        SyncDepFldUtilities.SyncFields(DepFieldTxt, NewFieldTxt, PreviousRecord."Registration No. CZL", PreviousRecord."Registration Number");
        Rec."Registration No. CZL" := CopyStr(DepFieldTxt, 1, MaxStrLen(Rec."Registration No. CZL"));
        Rec."Registration Number" := CopyStr(NewFieldTxt, 1, MaxStrLen(Rec."Registration Number"));
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Registration No. CZL', false, false)]
    local procedure SyncOnAfterValidateRegistrationNoCZL(var Rec: Record Customer)
    begin
        Rec."Registration Number" := Rec."Registration No. CZL";
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Registration Number', false, false)]
    local procedure SyncOnAfterValidateVatReportingDate(var Rec: Record Customer)
    begin
        Rec."Registration No. CZL" := Rec.GetRegistrationNoTrimmedCZL();
    end;
}
#endif