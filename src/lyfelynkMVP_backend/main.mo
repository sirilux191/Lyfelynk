import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Int "mo:base/Int";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Map "mo:map/Map";
import { phash; thash } "mo:map/Map";
import Source "mo:uuid/async/SourceV4";
import UUID "mo:uuid/UUID";

import TokenTypes "TokenTypes";
import Types "Types";

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

  let userListings = Map.new<Principal, HashMap.HashMap<Text, Types.Listing>>();
  //AUTHENTICATION FUNCTIONS
  public shared ({ caller }) func whoami() : async Principal {
    return caller;
  };

  public shared ({ caller }) func isRegistered() : async Text {
    if (Map.has(healthFacilityIDMap, phash, caller)) {
      return "Facility";
    } else if (Map.has(healthProfessionalIDMap, phash, caller)) {
      return "Professional";
    } else if (Map.has(healthUserIDMap, phash, caller)) {
      return "User";
    } else {
      return "Not Registered";
    };
  };
  //AUTHENTICATION FUNCTIONS

  // CRUD OPERATIONS USER ID

  public shared ({ caller }) func createUser(demoInfo : Blob, basicHealthPara : Blob, bioMData : ?Blob, familyData : ?Blob) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous persons can't register, please login with wallet or internet identity");
    };
    if (Map.has(healthUserIDMap, phash, caller) or Map.has(healthProfessionalIDMap, phash, caller) or Map.has(healthFacilityIDMap, phash, caller)) {
      return #err("You are already registered in one of the categories. Cannot register as a Health User.");
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
    #ok(Nat.toText(userRegistrationNumberCount));
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

    if (Map.has(healthUserIDMap, phash, caller) or Map.has(healthProfessionalIDMap, phash, caller) or Map.has(healthFacilityIDMap, phash, caller)) {
      return #err("You are already registered in one of the categories. Cannot register as a Health Professional.");
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

    if (Map.has(healthUserIDMap, phash, caller) or Map.has(healthProfessionalIDMap, phash, caller) or Map.has(healthFacilityIDMap, phash, caller)) {
      return #err("You are already registered in one of the categories. Cannot register as a Health Facility.");
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
        let uniqueID = userID # "-" # timestamp;

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
                let docInAssetMap = assetMap.get(timestamp);
                switch (docInAssetMap) {
                  case (?doc) {
                    let tempArray1 = Map.get(dataAccessPT, phash, userIDResult);
                    switch (tempArray1) {
                      case (?array) {
                        let buff = Buffer.fromArray<Text>(array);
                        buff.add(ownerID # "-" # timestamp);
                        Map.set(dataAccessPT, phash, userIDResult, Buffer.toArray(buff));
                      };
                      case (null) {
                        Map.set(dataAccessPT, phash, userIDResult, [ownerID # "-" # timestamp]);
                      };
                    };
                    let tempArray2 = Map.get(dataAccessTP, thash, ownerID # "-" # timestamp);
                    switch (tempArray2) {
                      case (?array) {
                        let buff = Buffer.fromArray<Principal>(array);
                        buff.add(userIDResult);
                        Map.set(dataAccessTP, thash, ownerID # "-" # timestamp, Buffer.toArray(buff));
                      };
                      case (null) {
                        Map.set(dataAccessTP, thash, ownerID # "-" # timestamp, [userIDResult]);
                      };
                    };

                    // Add the shared activity information to the sharedFileList map
                    let sharedInfo : Types.sharedActivityInfo = {
                      assetID = ownerID # "-" # timestamp;
                      usedSharedTo = userID;
                      time = Int.abs(Time.now());
                      sharedType = #Shared;
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
                    #ok("Sucessfully access given to user with ID " # userID);
                  };
                  case (null) {
                    #err("No Such Document Asset Found");
                  };
                };
              };
              case (null) {
                #err("No data asset available");
              };
            };
          };
          case (null) {
            #err("You are not registered");
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
                      if (val != ownerID # "-" # timestamp) {
                        buff.add(val);
                      };
                    };
                    Map.set(dataAccessPT, phash, userIDResult, Buffer.toArray(buff));
                  };
                  case (null) {};
                };
                let tempArray2 = Map.get(dataAccessTP, thash, ownerID # "-" # timestamp);
                switch (tempArray2) {
                  case (?array) {
                    let buff = Buffer.Buffer<Principal>(array.size());
                    for (val in array.vals()) {
                      if (val != userIDResult) {
                        buff.add(val);
                      };
                    };
                    Map.set(dataAccessTP, thash, ownerID # "-" # timestamp, Buffer.toArray(buff));
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
                        item.assetID != ownerID # "-" # timestamp;
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

  public shared query ({ caller }) func getSharedDataAssets() : async Result.Result<[(Text, Types.DataAsset)], Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous principals cannot access shared data assets. Please log in with a wallet or internet identity.");
    };

    let userID = Map.get(principalIDMap, phash, caller);

    switch (userID) {
      case (?id) {
        let sharedAssetIDs = Map.get(dataAccessPT, phash, caller);
        switch (sharedAssetIDs) {
          case (?assetIDs) {
            let sharedAssets = Buffer.Buffer<(Text, Types.DataAsset)>(0);
            for (assetID in assetIDs.vals()) {
              let parts = Text.split(assetID, #text("-"));
              switch (parts.next(), parts.next(), parts.next()) {
                case (?ownerID, ?timestamp, null) {
                  if (ownerID != id) {
                    let dataAssetMap = Map.get(dataAssetStorage, thash, ownerID);
                    switch (dataAssetMap) {
                      case (?assetMap) {
                        let dataAsset = assetMap.get(timestamp);
                        switch (dataAsset) {
                          case (?asset) {
                            sharedAssets.add((assetID, asset));
                          };
                          case (null) {};
                        };
                      };
                      case (null) {};
                    };
                  };
                };
                case (_) {
                  // Handle invalid assetID format if needed
                };
              };
            };
            return #ok(Buffer.toArray(sharedAssets));
          };
          case (null) {
            return #err("No data assets have been shared with you.");
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
    timestamp : Text,
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
            let assetData = assetMap.get(timestamp);
            switch (assetData) {
              case (?asset) {
                let g = Source.Source();
                let uuidToSplit = Text.split(UUID.toText(await g.new()), #char '-');
                let uuid = Text.join("", uuidToSplit);
                let listingID = uuid # "-" # timestamp;

                let newListing : Types.Listing = {
                  title;
                  description;
                  price;
                  category;
                  seller = Principal.toText(caller);
                  assetID = listingID;
                };

                let existingListings = Map.get(userListings, phash, caller);
                switch (existingListings) {
                  case (?listings) {
                    listings.put(listingID, newListing);
                    Map.set(userListings, phash, caller, listings);
                  };
                  case (null) {
                    let newListingMap = HashMap.HashMap<Text, Types.Listing>(1, Text.equal, Text.hash);
                    newListingMap.put(listingID, newListing);
                    Map.set(userListings, phash, caller, newListingMap);
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

  public shared ({ caller }) func deleteListingByAssetID(listingID : Text) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous principals cannot delete listings. Please log in with a wallet or internet identity.");
    };

    let listings = Map.get(userListings, phash, caller);
    switch (listings) {
      case (?listings) {
        let result = listings.remove(listingID);
        switch (result) {
          case (?listing) {
            Map.set(userListings, phash, caller, listings);
            return #ok("Listing deleted successfully.");
          };
          case (null) {
            return #err("Listing with the provided listing ID not found.");
          };
        };
      };
      case (null) {
        return #err("You have no listings.");
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

  public shared query ({ caller }) func getUserListings() : async Result.Result<[Types.Listing], Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous principals cannot access user listings. Please log in with a wallet or internet identity.");
    };

    let listings = Map.get(userListings, phash, caller);
    switch (listings) {
      case (?listings) {
        let userListings = Buffer.Buffer<Types.Listing>(0);
        for (listing in listings.vals()) {
          userListings.add(listing);
        };
        return #ok(Buffer.toArray(userListings));
      };
      case (null) {
        return #err("You have no listings.");
      };
    };
  };

  type TOKEN_CANISTER_API = actor {
    icrc1_balance_of : shared query TokenTypes.Account -> async Nat;
    icrc1_transfer : shared TokenTypes.TransferArg -> async TokenTypes.Result;
    icrc2_allowance : shared query TokenTypes.AllowanceArgs -> async TokenTypes.Allowance;
    icrc2_approve : shared TokenTypes.ApproveArgs -> async TokenTypes.Result_1;
    icrc2_transfer_from : shared TokenTypes.TransferFromArgs -> async TokenTypes.Result_2;
  };

  let tokenCanister_api : TOKEN_CANISTER_API = actor ("344ue-aaaaa-aaaag-ak6fq-cai");

  public shared ({ caller }) func purchaseListing(listingID : Text, sellerText : Text) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Anonymous principals cannot purchase listings. Please log in with a wallet or internet identity.");
    };

    let buyerID = Map.get(principalIDMap, phash, caller);
    switch (buyerID) {
      case (?buyerID) {
        let seller = Principal.fromText(sellerText);
        let sellerListings = Map.get(userListings, phash, seller);
        switch (sellerListings) {
          case (?listings) {
            let listing = listings.get(listingID);
            switch (listing) {
              case (?listing) {

                let parts = Text.split(listingID, #text("-"));
                switch (parts.next(), parts.next(), parts.next()) {
                  case (?uuid, ?timestamp, null) {
                    let sellerID = Map.get(principalIDMap, phash, seller);

                    switch (sellerID) {
                      case (?sellerID) {

                        let balanceBuyer = await tokenCanister_api.icrc1_balance_of({
                          owner = caller;
                          subaccount = null;
                        });

                        if (balanceBuyer < listing.price * 100000000 + 10000) {
                          return #err("Not enough Funds");
                        };

                        let tokenTransferResult = await tokenCanister_api.icrc1_transfer({
                          to = {
                            owner = seller;
                            subaccount = null;
                          };
                          amount = listing.price * 100000000;
                          fee = ?10000;
                          memo = null;
                          created_at_time = null;
                          from_subaccount = null;
                        });

                        switch (tokenTransferResult) {
                          case (#Err(transfererror)) {
                            return #err("This error occurred " # debug_show (transfererror));
                          };
                          case (_) {};
                        };

                        let uniqueID = sellerID # "-" # timestamp;

                        // Update dataAccessPT map
                        let tempArray1 = Map.get(dataAccessPT, phash, caller);
                        switch (tempArray1) {
                          case (?array) {
                            let buff = Buffer.fromArray<Text>(array);
                            buff.add(uniqueID);
                            Map.set(dataAccessPT, phash, caller, Buffer.toArray(buff));
                          };
                          case (null) {
                            Map.set(dataAccessPT, phash, caller, [uniqueID]);
                          };
                        };

                        // Update dataAccessTP map
                        let tempArray2 = Map.get(dataAccessTP, thash, uniqueID);
                        switch (tempArray2) {
                          case (?array) {
                            let buff = Buffer.fromArray<Principal>(array);
                            buff.add(caller);
                            Map.set(dataAccessTP, thash, uniqueID, Buffer.toArray(buff));
                          };
                          case (null) {
                            Map.set(dataAccessTP, thash, uniqueID, [caller]);
                          };
                        };

                        let sharedInfo : Types.sharedActivityInfo = {
                          assetID = uniqueID;
                          usedSharedTo = buyerID;
                          time = Int.abs(Time.now());
                          sharedType = #Sold;
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

                        #ok("Listing purchased successfully. Access granted to the buyer.");
                      };
                      case (null) {
                        return #err("Seller not found.");
                      };
                    };
                  };
                  case (_) {
                    return #err("Invalid listing ID format.");
                  };
                };
              };
              case (null) {
                return #err("Listing not found for the provided listing ID.");
              };
            };
          };
          case (null) {
            return #err("Seller has no listings.");
          };
        };
      };
      case (null) {
        return #err("Caller is not a registered user.");
      };
    };
  };

};
