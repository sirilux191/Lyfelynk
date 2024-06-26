import Blob "mo:base/Blob";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
module Types {

    public type SharedType = {
        #Sold;
        #Shared;
    };

    public type Metadata = {
        category : Text;
        tags : [Text];
        format : Text; //  e.g., "CSV", "JSON", "image/png"
    };

    public type HealthIDUserData = {
        DemographicInformation : Blob;
        BasicHealthParameters : Blob;
        BiometricData : ?Blob;
        FamilyInformation : ?Blob;
    };
    public type HealthIDUser = {
        IDNum : Text;
        UUID : Text;
        MetaData : HealthIDUserData;
    };

    public type HealthIDProfessionalData = {
        DemographicInformation : Blob;
        OccupationInformation : Blob;
        CertificationInformation : Blob;
    };
    public type HealthIDProfessional = {
        IDNum : Text;
        UUID : Text;
        MetaData : HealthIDProfessionalData;
    };

    public type HealthIDFacilityData = {
        DemographicInformation : Blob;
        ServicesOfferedInformation : Blob;
        LicenseInformation : Blob;
    };
    public type HealthIDFacility = {
        IDNum : Text;
        UUID : Text;
        MetaData : HealthIDFacilityData;
    };

    public type DataAsset = {
        title : Text;
        description : Text;
        data : Blob;
        metadata : Metadata;
    };

    public type DataAssetInfo = {
        title : Text;
        description : Text;
        metadata : Metadata;
    };

    public type sharedActivityInfo = {
        assetID : Text;
        usedSharedTo : Text;
        time : Nat;
        sharedType : SharedType;
    };

    public type Listing = {
        title : Text;
        description : Text;
        price : Nat;
        category : Text;
        seller : Text;
        assetID : Text;
    };

    public type purchasedInfo = {
        title : Text;
        listingID : Text;
        price : Nat;
        assetID : Text;
        time : Nat;
        seller : Text;
    };

    public type TokenRequestAmounts = {
        currentRequestAmount : Nat;
        approvedTillNow : Nat;
    };
};
