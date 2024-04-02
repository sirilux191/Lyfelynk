import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Map "mo:map/Map";
import { phash; thash } "mo:map/Map";
import Source "mo:uuid/async/SourceV4";
import UUID "mo:uuid/UUID";

import Types "Types";
import Hex "utils/Hex";

actor LyfeLynk {
  let healthUserIDMap = Map.new<Principal, Types.HealthIDUser>();
  let healthProfessionalIDMap = Map.new<Principal, Types.HealthIDProfessional>();
  let healthFacilityIDMap = Map.new<Principal, Types.HealthIDFacility>();

  let principalIDMap = Map.new<Principal, Text>(); //Map of Principal of User with Health ID
  let idPrincipalMap = Map.new<Text, Principal>(); //Map of Health ID of User with Principal

  let dataAssetStorage = Map.new<Text, HashMap.HashMap<Text, Types.DataAsset>>(); //UserID <---> Timestamp <---> DataAsset
  let dataAccessTP = Map.new<Text, [Principal]>(); //AssetIDUnique <---> user
  let dataAccessPT = Map.new<Principal, [Text]>(); //User <---> AssetIDUnique
  let sharedFileList = Map.new<Principal, [Types.sharedActivityInfo]>();

  stable var userRegistrationNumberCount : Nat = 10000000000000;
  stable var profRegistrationNumberCount : Nat = 100000000000;
  stable var facilityRegistrationNumberCount : Nat = 1000000000;

  let userListings = Map.new<Principal, [Types.Listing]>();
  //AUTHENTICATION FUNCTIONS

  //AUTHENTICATION FUNCTIONS

  // CRUD OPERATIONS USER ID

  public shared ({ caller }) func createUser(demoInfo : Blob, basicHealthPara : Blob, bioMData : ?Blob, familyData : ?Blob) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't register, please login with wallet or internet identity");
    };

    let g = Source.Source();
    let uuid = UUID.toText(await g.new());
    userRegistrationNumberCount := userRegistrationNumberCount +1;
    let tempIDData : Types.HealthIDUserData = {
      DemographicInformation = demoInfo;
      BasicHealthParameters = basicHealthPara;
      BiometricData = bioMData;
      FamilyInformation = familyData;
    };
    let tempID : Types.HealthIDUser = {
      IDNum = Nat.toText(userRegistrationNumberCount);
      UUID = uuid;
      MetaData = tempIDData;
    };
    Map.set(healthUserIDMap, phash, caller, tempID);
    Map.set(principalIDMap, phash, caller, Nat.toText(userRegistrationNumberCount));
    Map.set(idPrincipalMap, thash, Nat.toText(userRegistrationNumberCount), caller);
    #ok("Your unique Health ID is:" # Nat.toText(userRegistrationNumberCount));
  };

  public shared ({ caller }) func readUser() : async Result.Result<Types.HealthIDUser, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't register, please login with wallet or internet identity");
    };

    let readResult = Map.get(healthUserIDMap, phash, caller);
    switch (readResult) {
      case (?value) { #ok(value) };
      case (null) { #err("Your not registered as Health User") };
    };
  };

  public shared ({ caller }) func updateUser(demoInfo : Blob, basicHealthPara : Blob, bioMData : ?Blob, familyData : ?Blob) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't update, please login with wallet or internet identity");
    };

    let readResult = Map.get(healthUserIDMap, phash, caller);
    switch (readResult) {
      case (?value) {
        let tempIDData : Types.HealthIDUserData = {
          DemographicInformation = demoInfo;
          BasicHealthParameters = basicHealthPara;
          BiometricData = bioMData;
          FamilyInformation = familyData;
        };

        let updatedID : Types.HealthIDUser = {
          IDNum = value.IDNum;
          UUID = value.UUID;
          MetaData = tempIDData;
        };

        Map.set(healthUserIDMap, phash, caller, updatedID);
        #ok("User health ID updated successfully");
      };
      case (null) {
        #err("You're not registered as a Health User");
      };
    };
  };

  public shared ({ caller }) func deleteUser() : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't delete, please login with wallet or internet identity");
    };

    let readResult = Map.get(healthUserIDMap, phash, caller);
    switch (readResult) {
      case (?value) {
        Map.delete(healthUserIDMap, phash, caller);
        Map.delete(principalIDMap, phash, caller);
        Map.delete(idPrincipalMap, thash, value.IDNum);
        #ok("User health ID deleted successfully");
      };
      case (null) {
        #err("You're not registered as a Health User");
      };
    };
  };

  // CRUD OPERATIONS USER ID

  // CRUD OPERATIONS PROFESSIONAL ID
  public shared ({ caller }) func createProfessional(demoInfo : Blob, occupationInfo : Blob, certificationInfo : Blob) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't register, please login with wallet or internet identity");
    };

    let g = Source.Source();
    let uuid = UUID.toText(await g.new());
    profRegistrationNumberCount := profRegistrationNumberCount + 1;
    let tempIDData : Types.HealthIDProfessionalData = {
      DemographicInformation = demoInfo;
      OccupationInformation = occupationInfo;
      CertificationInformation = certificationInfo;
    };
    let tempID : Types.HealthIDProfessional = {
      IDNum = Nat.toText(profRegistrationNumberCount);
      UUID = uuid;
      MetaData = tempIDData;
    };
    Map.set(healthProfessionalIDMap, phash, caller, tempID);
    Map.set(principalIDMap, phash, caller, Nat.toText(profRegistrationNumberCount));
    Map.set(idPrincipalMap, thash, Nat.toText(profRegistrationNumberCount), caller);
    #ok("Your unique Health Professional ID is:" # Nat.toText(profRegistrationNumberCount));
  };

  public shared ({ caller }) func readProfessional() : async Result.Result<Types.HealthIDProfessional, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't register, please login with wallet or internet identity");
    };

    let readResult = Map.get(healthProfessionalIDMap, phash, caller);
    switch (readResult) {
      case (?value) { #ok(value) };
      case (null) {
        #err("You're not registered as a Health Professional");
      };
    };
  };

  public shared ({ caller }) func updateProfessional(demoInfo : Blob, occupationInfo : Blob, certificationInfo : Blob) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't update, please login with wallet or internet identity");
    };

    let readResult = Map.get(healthProfessionalIDMap, phash, caller);
    switch (readResult) {
      case (?value) {
        let tempIDData : Types.HealthIDProfessionalData = {
          DemographicInformation = demoInfo;
          OccupationInformation = occupationInfo;
          CertificationInformation = certificationInfo;
        };

        let updatedID : Types.HealthIDProfessional = {
          IDNum = value.IDNum;
          UUID = value.UUID;
          MetaData = tempIDData;
        };

        Map.set(healthProfessionalIDMap, phash, caller, updatedID);
        #ok("Professional health ID updated successfully");
      };
      case (null) {
        #err("You're not registered as a Health Professional");
      };
    };
  };

  public shared ({ caller }) func deleteProfessional() : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't delete, please login with wallet or internet identity");
    };

    let readResult = Map.get(healthProfessionalIDMap, phash, caller);
    switch (readResult) {
      case (?value) {
        Map.delete(healthProfessionalIDMap, phash, caller);
        Map.delete(principalIDMap, phash, caller);
        Map.delete(idPrincipalMap, thash, value.IDNum);
        #ok("Professional health ID deleted successfully");
      };
      case (null) {
        #err("You're not registered as a Health Professional");
      };
    };
  };

  // CRUD OPERATIONS FACILITY ID
  public shared ({ caller }) func createFacility(demoInfo : Blob, servicesOfferedInfo : Blob, licenseInfo : Blob) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't register, please login with wallet or internet identity");
    };

    let g = Source.Source();
    let uuid = UUID.toText(await g.new());
    facilityRegistrationNumberCount := facilityRegistrationNumberCount + 1;
    let tempIDData : Types.HealthIDFacilityData = {
      DemographicInformation = demoInfo;
      ServicesOfferedInformation = servicesOfferedInfo;
      LicenseInformation = licenseInfo;
    };
    let tempID : Types.HealthIDFacility = {
      IDNum = Nat.toText(facilityRegistrationNumberCount);
      UUID = uuid;
      MetaData = tempIDData;
    };
    Map.set(healthFacilityIDMap, phash, caller, tempID);
    Map.set(principalIDMap, phash, caller, Nat.toText(facilityRegistrationNumberCount));
    Map.set(idPrincipalMap, thash, Nat.toText(facilityRegistrationNumberCount), caller);
    #ok("Your unique Health Facility ID is:" # Nat.toText(facilityRegistrationNumberCount));
  };

  public shared ({ caller }) func readFacility() : async Result.Result<Types.HealthIDFacility, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't register, please login with wallet or internet identity");
    };

    let readResult = Map.get(healthFacilityIDMap, phash, caller);
    switch (readResult) {
      case (?value) { #ok(value) };
      case (null) { #err("You're not registered as a Health Facility") };
    };
  };

  public shared ({ caller }) func updateFacility(demoInfo : Blob, servicesOfferedInfo : Blob, licenseInfo : Blob) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't update, please login with wallet or internet identity");
    };

    let readResult = Map.get(healthFacilityIDMap, phash, caller);
    switch (readResult) {
      case (?value) {
        let tempIDData : Types.HealthIDFacilityData = {
          DemographicInformation = demoInfo;
          ServicesOfferedInformation = servicesOfferedInfo;
          LicenseInformation = licenseInfo;
        };

        let updatedID : Types.HealthIDFacility = {
          IDNum = value.IDNum;
          UUID = value.UUID;
          MetaData = tempIDData;
        };

        Map.set(healthFacilityIDMap, phash, caller, updatedID);
        #ok("Facility health ID updated successfully");
      };
      case (null) {
        #err("You're not registered as a Health Facility");
      };
    };
  };

  public shared ({ caller }) func deleteFacility() : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't delete, please login with wallet or internet identity");
    };

    let readResult = Map.get(healthFacilityIDMap, phash, caller);
    switch (readResult) {
      case (?value) {
        Map.delete(healthFacilityIDMap, phash, caller);
        Map.delete(principalIDMap, phash, caller);
        Map.delete(idPrincipalMap, thash, value.IDNum);
        #ok("Facility health ID deleted successfully");
      };
      case (null) {
        #err("You're not registered as a Health Facility");
      };
    };
  };

  // Link health data with user's health ID
  public shared ({ caller }) func linkHealthData(healthData : Types.DataAsset) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't link health data, please login with wallet or internet identity");
    };

    let userIDResult = Map.get(principalIDMap, phash, caller);
    switch (userIDResult) {
      case (?userID) {
        let timestamp = Int.toText(Time.now());
        let uniqueID = userID # timestamp;

        let healthDataMap = Map.get(dataAssetStorage, thash, userID);
        switch (healthDataMap) {
          case (?existingDataMap) {
            existingDataMap.put(timestamp, healthData);
            Map.set(dataAssetStorage, thash, userID, existingDataMap);
            Map.set(dataAccessPT, phash, caller, [uniqueID]);
            Map.set(dataAccessTP, thash, uniqueID, [caller]);
            #ok(uniqueID);
          };
          case (null) {
            let newDataMap = HashMap.HashMap<Text, Types.DataAsset>(0, Text.equal, Text.hash);
            newDataMap.put(timestamp, healthData);
            Map.set(dataAssetStorage, thash, userID, newDataMap);

            Map.set(dataAccessPT, phash, caller, [uniqueID]);
            Map.set(dataAccessTP, thash, uniqueID, [caller]);
            #ok(uniqueID);
          };
        };
      };
      case (null) {
        #err("You're not registered.");
      };
    };
  };

  // Grant access to a health data asset
  public shared ({ caller }) func grantDataAccess(userID : Text, timestamp : Text) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't grant access, please login with wallet or internet identity");
    };

    let userIDResult = Map.get(idPrincipalMap, thash, userID);
    switch (userIDResult) {
      case (?userIDResult) {
        let ownerID = Map.get(principalIDMap, phash, caller);
        switch (ownerID) {
          case (?ownerID) {
            let dataAssetMap = Map.get(dataAssetStorage, thash, ownerID);
            switch (dataAssetMap) {
              case (?assetMap) {
                let tempArray1 = Map.get(dataAccessPT, phash, userIDResult);
                switch (tempArray1) {
                  case (?array) {
                    let buff = Buffer.fromArray<Text>(array);
                    buff.add(userID #timestamp);
                    Map.set(dataAccessPT, phash, userIDResult, Buffer.toArray(buff));
                  };
                  case (null) {
                    Map.set(dataAccessPT, phash, userIDResult, [userID #timestamp]);
                  };
                };
                let tempArray2 = Map.get(dataAccessTP, thash, userID #timestamp);
                switch (tempArray2) {
                  case (?array) {
                    let buff = Buffer.fromArray<Principal>(array);
                    buff.add(userIDResult);
                    Map.set(dataAccessTP, thash, userID #timestamp, Buffer.toArray(buff));
                  };
                  case (null) {
                    Map.set(dataAccessTP, thash, userID #timestamp, [userIDResult]);
                  };
                };

                // Add the shared activity information to the sharedFileList map
                let sharedInfo : Types.sharedActivityInfo = {
                  assetID = userID # timestamp;
                  usedSharedTo = userID;
                  time = Int.abs(Time.now());
                };

                let ownerSharedFiles = Map.get(sharedFileList, phash, caller);
                switch (ownerSharedFiles) {
                  case (?files) {
                    let buff = Buffer.fromArray<Types.sharedActivityInfo>(files);
                    buff.add(sharedInfo);
                    Map.set(sharedFileList, phash, caller, Buffer.toArray(buff));
                  };
                  case (null) {
                    Map.set(sharedFileList, phash, caller, [sharedInfo]);
                  };
                };
                #ok("Sucessfully access given to user with ID " #userID);
              };
              case (null) {
                #err("No data asset available");
              };
            };
          };
          case (null) {
            #err("Invalid user");
          };
        };

      };
      case (null) {
        #err("Invalid user ID.");
      };
    };
  };

  // Revoke access to a health data asset
  public shared ({ caller }) func revokeDataAccess(userID : Text, timestamp : Text) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't revoke access, please login with wallet or internet identity");
    };

    let userIDResult = Map.get(idPrincipalMap, thash, userID);
    switch (userIDResult) {
      case (?userIDResult) {
        let ownerID = Map.get(principalIDMap, phash, caller);
        switch (ownerID) {
          case (?ownerID) {
            let dataAssetMap = Map.get(dataAssetStorage, thash, ownerID);
            switch (dataAssetMap) {
              case (?assetMap) {
                let tempArray1 = Map.get(dataAccessPT, phash, userIDResult);
                switch (tempArray1) {
                  case (?array) {
                    let buff = Buffer.Buffer<Text>(array.size());
                    for (val in array.vals()) {
                      if (val != userID #timestamp) {
                        buff.add(val);
                      };
                    };
                    Map.set(dataAccessPT, phash, userIDResult, Buffer.toArray(buff));
                  };
                  case (null) {};
                };
                let tempArray2 = Map.get(dataAccessTP, thash, userID #timestamp);
                switch (tempArray2) {
                  case (?array) {
                    let buff = Buffer.Buffer<Principal>(array.size());
                    for (val in array.vals()) {
                      if (val != userIDResult) {
                        buff.add(val);
                      };
                    };
                    Map.set(dataAccessTP, thash, userID #timestamp, Buffer.toArray(buff));
                  };
                  case (null) {};
                };

                // Remove the shared activity information from the sharedFileList map
                let ownerSharedFiles = Map.get(sharedFileList, phash, caller);
                switch (ownerSharedFiles) {
                  case (?files) {
                    let updatedFiles = Array.filter(
                      files,
                      func(item : Types.sharedActivityInfo) : Bool {
                        item.assetID != userID # timestamp;
                      },
                    );
                    Map.set(sharedFileList, phash, caller, updatedFiles);
                  };
                  case (null) {};
                };
                #ok("Access revoked for user with ID " #userID);

              };
              case (null) {
                #err("No data asset available");
              };
            };
          };
          case (null) {
            #err("Invalid user");
          };
        };

      };
      case (null) {
        #err("Invalid user ID.");
      };
    };
  };

  public shared query ({ caller }) func getSharedFileList() : async Result.Result<[Types.sharedActivityInfo], Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't revoke access, please login with wallet or internet identity");
    };
    let list = Map.get(sharedFileList, phash, caller);
    switch (list) {
      case (?value) {
        #ok(value);
      };
      case (null) {
        #err("No activity of user");
      };
    };
  };

  public shared query ({ caller }) func getUserDataAssets() : async Result.Result<[(Text, Types.DataAsset)], Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous principals cannot access data assets. Please log in with a wallet or internet identity.");
    };

    let userID = Map.get(principalIDMap, phash, caller);
    switch (userID) {
      case (?id) {
        let dataAssetMap = Map.get(dataAssetStorage, thash, id);
        switch (dataAssetMap) {
          case (?assetMap) {
            let assetList = Iter.toArray<(Text, Types.DataAsset)>(assetMap.entries());
            return #ok(assetList);
          };
          case (null) {
            return #err("No data assets found for the user.");
          };
        };
      };
      case (null) {
        return #err("Caller is not a registered user.");
      };
    };
  };

  public shared ({ caller }) func addListing(
    title : Text,
    description : Text,
    price : Nat,
    category : Text,
    assetID : Text,
  ) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous principals cannot add listings. Please log in with a wallet or internet identity.");
    };

    let userID = Map.get(principalIDMap, phash, caller);
    switch (userID) {
      case (?id) {
        let dataAssetMap = Map.get(dataAssetStorage, thash, id);
        switch (dataAssetMap) {
          case (?assetMap) {
            let assetData = assetMap.get(assetID);
            switch (assetData) {
              case (?asset) {
                let newListing : Types.Listing = {
                  title;
                  description;
                  price;
                  category;
                  seller = caller;
                  assetID = assetID;
                };

                let existingListings = Map.get(userListings, phash, caller);
                switch (existingListings) {
                  case (?listings) {
                    let buff = Buffer.fromArray<Types.Listing>(listings);
                    buff.add(newListing);
                    Map.set(userListings, phash, caller, Buffer.toArray(buff));
                  };
                  case (null) {
                    Map.set(userListings, phash, caller, [newListing]);
                  };
                };

                return #ok("Listing added successfully");
              };
              case (null) {
                return #err("No data asset found for the provided timestamp.");
              };
            };
          };
          case (null) {
            return #err("User has no data assets.");
          };
        };
      };
      case (null) {
        return #err("Caller is not a registered user.");
      };
    };
  };

  public shared ({ caller }) func deleteListingByAssetID(assetID : Text) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous principals cannot delete listings. Please log in with a wallet or internet identity.");
    };

    let userID = Map.get(principalIDMap, phash, caller);
    switch (userID) {
      case (?id) {
        let listings = Map.get(userListings, phash, caller);
        switch (listings) {
          case (?listings) {
            let filteredListings = Array.filter<Types.Listing>(
              listings,
              func(listing : Types.Listing) : Bool {
                listing.assetID != assetID;
              },
            );

            if (filteredListings.size() == listings.size()) {
              return #err("Listing with the provided asset ID not found.");
            };

            Map.set(userListings, phash, caller, filteredListings);
            return #ok("Listing deleted successfully.");
          };
          case (null) {
            return #err("You have no listings.");
          };
        };
      };
      case (null) {
        return #err("Caller is not a registered user.");
      };
    };
  };

  public shared query func getAllListings() : async Result.Result<[Types.Listing], Text> {

    if (Map.size(userListings) == 0) {
      return #err("No listings found.");
    };

    let allListings = Buffer.Buffer<Types.Listing>(0);

    for ((user, listings) in Map.entries(userListings)) {
      for (listing in listings.vals()) {
        allListings.add(listing);
      };
    };

    if (allListings.size() == 0) {
      return #err("No listings found.");
    };

    return #ok(Buffer.toArray(allListings));
  };

  //VetKey Section

  type VETKD_SYSTEM_API = actor {
    vetkd_public_key : ({
      canister_id : ?Principal;
      derivation_path : [Blob];
      key_id : { curve : { #bls12_381 }; name : Text };
    }) -> async ({ public_key : Blob });
    vetkd_encrypted_key : ({
      public_key_derivation_path : [Blob];
      derivation_id : Blob;
      key_id : { curve : { #bls12_381 }; name : Text };
      encryption_public_key : Blob;
    }) -> async ({ encrypted_key : Blob });
  };

  let vetkd_system_api : VETKD_SYSTEM_API = actor ("s55qq-oqaaa-aaaaa-aaakq-cai");

  public shared ({ caller }) func symmetric_key_verification_key_for_profile() : async Text {
    let { public_key } = await vetkd_system_api.vetkd_public_key({
      canister_id = null;
      derivation_path = Array.make(Text.encodeUtf8("profile_symmetric_key"));
      key_id = { curve = #bls12_381; name = "test_key_1" };
    });
    Hex.encode(Blob.toArray(public_key));
  };

  public shared ({ caller }) func encrypted_symmetric_key_for_id(profile_id : Text, encryption_public_key : Blob) : async Result.Result<Text, Text> {
    let principal = Map.get(idPrincipalMap, thash, profile_id);
    switch (principal) {
      case (?principal) {
        if (principal != caller) {
          return #err("Unauthorized access. The provided profile ID does not belong to the caller.");
        };

        let profile_data = if (profile_id.size() == 14) {
          Map.get(healthUserIDMap, phash, caller);
        } else if (profile_id.size() == 12) {
          Map.get(healthProfessionalIDMap, phash, caller);
        } else if (profile_id.size() == 10) {
          Map.get(healthFacilityIDMap, phash, caller);
        } else {
          return #err("Invalid profile ID length.");
        };
        let idToDerive = Nat.fromText(profile_id);
        switch (idToDerive) {
          case (?idToDerive) {
            switch (profile_data) {
              case (?profile_data) {
                let buf = Buffer.Buffer<Nat8>(32);
                buf.append(Buffer.fromArray(natToBigEndianByteArray(16, idToDerive))); // fixed-size encoding
                buf.append(Buffer.fromArray(Blob.toArray(Text.encodeUtf8(profile_data.UUID))));
                let derivation_id = Blob.fromArray(Buffer.toArray(buf));

                let { encrypted_key } = await vetkd_system_api.vetkd_encrypted_key({
                  derivation_id;
                  public_key_derivation_path = Array.make(Text.encodeUtf8("profile_symmetric_key"));
                  key_id = { curve = #bls12_381; name = "test_key_1" };
                  encryption_public_key;
                });

                #ok(Hex.encode(Blob.toArray(encrypted_key)));
              };
              case (null) {
                #err("Profile data not found for the provided profile ID.");
              };
            };
          };
          case (null) {
            #err("Sorry you have to given proper profile ID");
          };
        };

      };
      case (null) {
        #err("Invalid profile ID. No principal associated with the provided ID.");
      };
    };
  };

  public shared ({ caller }) func encrypted_symmetric_key_for_data(assetID : Text, encryption_public_key : Blob) : async Result.Result<Text, Text> {
    let accessList = Map.get(dataAccessTP, thash, assetID);
    switch (accessList) {
      case (?accessList) {
        if (not Array.contains<Principal>(accessList, caller, Principal.equal)) {
          return #err("Unauthorized access. The caller does not have access to the data asset.");
        };

        let buf = Buffer.Buffer<Nat8>(32);
        buf.append(Buffer.fromArray(Blob.toArray(Text.encodeUtf8(assetID))));
        let derivation_id = Blob.fromArray(Buffer.toArray(buf));

        let { encrypted_key } = await vetkd_system_api.vetkd_encrypted_key({
          derivation_id;
          public_key_derivation_path = Array.make(Text.encodeUtf8("data_symmetric_key"));
          key_id = { curve = #bls12_381; name = "test_key_1" };
          encryption_public_key;
        });

        #ok(Hex.encode(Blob.toArray(encrypted_key)));
      };
      case (null) {
        #err("Data asset not found or access not granted.");
      };
    };
  };
  //VetKey Section

  // Converts a nat to a fixed-size big-endian byte (Nat8) array
  private func natToBigEndianByteArray(len : Nat, n : Nat) : [Nat8] {
    let ith_byte = func(i : Nat) : Nat8 {
      assert (i < len);
      let shift : Nat = 8 * (len - 1 - i);
      Nat8.fromIntWrap(n / 2 ** shift);
    };
    Array.tabulate<Nat8>(len, ith_byte);
  };
};
