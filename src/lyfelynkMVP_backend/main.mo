import Array "mo:base/Array";
import Blob "mo:base/Blob";
import Buffer "mo:base/Buffer";
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
import Hex "utility/Hex";

actor LyfeLynk {

  stable var admin = Principal.fromText("e5s2y-wkvcn-fze3a-a2dwf-5iz4d-iv3fb-nl4qb-7pezr-wepwa-pua6f-xqe");
  stable var healthUserIDMap = Map.new<Principal, Types.HealthIDUser>();
  stable var healthProfessionalIDMap = Map.new<Principal, Types.HealthIDProfessional>();
  stable var healthFacilityIDMap = Map.new<Principal, Types.HealthIDFacility>();

  stable var principalIDMap = Map.new<Principal, Text>(); //Map of Principal of User with Health ID
  stable var idPrincipalMap = Map.new<Text, Principal>(); //Map of Health ID of User with Principal

  stable var dataAssetStorage = Map.new<Text, Map.Map<Text, Types.DataAsset>>(); //UserID <---> Timestamp <---> DataAsset
  stable var dataAccessTP = Map.new<Text, [Principal]>(); //AssetIDUnique <---> [User]
  stable var dataAccessPT = Map.new<Principal, [Text]>(); //User <---> [AssetIDUnique]
  stable var sharedFileList = Map.new<Principal, [Types.sharedActivityInfo]>();
  stable var purchasedDataAssetList = Map.new<Principal, [Types.purchasedInfo]>();

  stable var tokenRequestMap = Map.new<Principal, Types.TokenRequestAmounts>();
  stable var userRegistrationNumberCount : Nat = 10000000000000;
  stable var profRegistrationNumberCount : Nat = 100000000000;
  stable var facilityRegistrationNumberCount : Nat = 1000000000;

  stable var userListings = Map.new<Principal, Map.Map<Text, Types.Listing>>();
  stable var numberOfTransactions = 0;

  //AUTHENTICATION FUNCTIONS
  public shared query ({ caller }) func whoami() : async Text {
    return Principal.toText(caller);
  };

  public func getActorPrincipal() : async Text {
    return Principal.toText(Principal.fromActor(LyfeLynk));
  };

  public shared query ({ caller }) func isRegistered() : async Text {
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

  public shared query ({ caller }) func getID() : async Result.Result<Text, Text> {
    switch (Map.get(principalIDMap, phash, caller)) {
      case (?value) { #ok(value) };
      case (null) { #err("Sorry looks your are not registered") };
    };
  };

  public query func getNumberOfUsers() : async [Nat] {
    return [userRegistrationNumberCount, profRegistrationNumberCount, facilityRegistrationNumberCount];
  };
  //AUTHENTICATION FUNCTIONS

  // CRUD OPERATIONS USER ID

  public shared ({ caller }) func createUser(demoInfo : Blob, basicHealthPara : Blob, bioMData : ?Blob, familyData : ?Blob) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please login with wallet or internet identity");
    };
    if (Map.has(healthUserIDMap, phash, caller) or Map.has(healthProfessionalIDMap, phash, caller) or Map.has(healthFacilityIDMap, phash, caller)) {
      return #err("You are already registered in one of the categories. Cannot register as a Health User.");
    };
    let g = Source.Source();
    let uuid = UUID.toText(await g.new());
    userRegistrationNumberCount := userRegistrationNumberCount + 1;
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

  public shared query ({ caller }) func readUser() : async Result.Result<Types.HealthIDUser, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please login with wallet or internet identity");
    };

    let readResult = Map.get(healthUserIDMap, phash, caller);
    switch (readResult) {
      case (?value) { #ok(value) };
      case (null) { #err("You are not registered as Health User") };
    };
  };

  public shared ({ caller }) func updateUser(demoInfo : Blob, basicHealthPara : Blob, bioMData : ?Blob, familyData : ?Blob) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please login with wallet or internet identity");
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
        #ok("User Health ID updated successfully");
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
        #ok("User Health ID deleted successfully");
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
      return #err("Please login with wallet or internet identity");
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
    #ok(Nat.toText(profRegistrationNumberCount));
  };

  public shared query ({ caller }) func readProfessional() : async Result.Result<Types.HealthIDProfessional, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please login with wallet or internet identity");
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
      return #err("Please login with wallet or internet identity");
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
      return #err("Please login with wallet or internet identity");
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
      return #err("Please login with wallet or internet identity");
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
    #ok(Nat.toText(facilityRegistrationNumberCount));
  };

  public shared query ({ caller }) func readFacility() : async Result.Result<Types.HealthIDFacility, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please login with wallet or internet identity");
    };

    let readResult = Map.get(healthFacilityIDMap, phash, caller);
    switch (readResult) {
      case (?value) { #ok(value) };
      case (null) { #err("You're not registered as a Health Facility") };
    };
  };

  public shared ({ caller }) func updateFacility(demoInfo : Blob, servicesOfferedInfo : Blob, licenseInfo : Blob) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please login with wallet or internet identity");
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
      return #err("Please login with wallet or internet identity");
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
      return #err("Please login with wallet or internet identity");
    };

    let userIDResult = Map.get(principalIDMap, phash, caller);
    switch (userIDResult) {
      case (?userID) {
        let timestamp = Int.toText(Time.now());
        let uniqueID = userID # "-" # timestamp;

        let healthDataMap = Map.get(dataAssetStorage, thash, userID);
        switch (healthDataMap) {
          case (?existingDataMap) {
            Map.set(existingDataMap, thash, timestamp, healthData);
            Map.set(dataAssetStorage, thash, userID, existingDataMap);

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

            #ok(uniqueID);
          };
          case (null) {
            let newDataMap = Map.new<Text, Types.DataAsset>();
            Map.set(newDataMap, thash, timestamp, healthData);
            Map.set(dataAssetStorage, thash, userID, newDataMap);

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

            #ok(uniqueID);
          };

        };
      };
      case (null) {
        #err("You're not registered.");
      };
    };
  };
  // Function to upload/link data on behalf of a user
  public shared ({ caller }) func uploadDataForUser(userID : Text, healthData : Types.DataAsset) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please login with wallet or internet identity");
    };

    // Check if the caller is a registered professional or facility
    let callerType = await isRegistered();
    if (callerType != "Professional" and callerType != "Facility") {
      return #err("Only registered professionals or facilities can upload data on behalf of users");
    };

    // Check if the provided userID is valid
    let userPrincipal = Map.get(idPrincipalMap, thash, userID);
    switch (userPrincipal) {
      case (?user) {
        let timestamp = Int.toText(Time.now());
        let uniqueID = userID # "-" # timestamp;

        // Link the health data to the user's health ID
        let healthDataMap = Map.get(dataAssetStorage, thash, userID);
        switch (healthDataMap) {
          case (?existingDataMap) {
            Map.set(existingDataMap, thash, timestamp, healthData);
            Map.set(dataAssetStorage, thash, userID, existingDataMap);

            // Update dataAccessPT map
            let tempArray1 = Map.get(dataAccessPT, phash, user);
            switch (tempArray1) {
              case (?array) {
                let buff = Buffer.fromArray<Text>(array);
                buff.add(uniqueID);
                Map.set(dataAccessPT, phash, user, Buffer.toArray(buff));
              };
              case (null) {
                Map.set(dataAccessPT, phash, user, [uniqueID]);
              };
            };

            // Update dataAccessTP map
            let tempArray2 = Map.get(dataAccessTP, thash, uniqueID);
            switch (tempArray2) {
              case (?array) {
                let buff = Buffer.fromArray<Principal>(array);
                buff.add(user);
                Map.set(dataAccessTP, thash, uniqueID, Buffer.toArray(buff));
              };
              case (null) {
                Map.set(dataAccessTP, thash, uniqueID, [user]);
              };
            };

            #ok(uniqueID);
          };
          case (null) {
            let newDataMap = Map.new<Text, Types.DataAsset>();
            Map.set(newDataMap, thash, timestamp, healthData);
            Map.set(dataAssetStorage, thash, userID, newDataMap);

            // Update dataAccessPT map
            let tempArray1 = Map.get(dataAccessPT, phash, user);
            switch (tempArray1) {
              case (?array) {
                let buff = Buffer.fromArray<Text>(array);
                buff.add(uniqueID);
                Map.set(dataAccessPT, phash, user, Buffer.toArray(buff));
              };
              case (null) {
                Map.set(dataAccessPT, phash, user, [uniqueID]);
              };
            };

            // Update dataAccessTP map
            let tempArray2 = Map.get(dataAccessTP, thash, uniqueID);
            switch (tempArray2) {
              case (?array) {
                let buff = Buffer.fromArray<Principal>(array);
                buff.add(user);
                Map.set(dataAccessTP, thash, uniqueID, Buffer.toArray(buff));
              };
              case (null) {
                Map.set(dataAccessTP, thash, uniqueID, [user]);
              };
            };

            #ok(uniqueID);
          };
        };
      };
      case (null) {
        #err("Invalid user ID");
      };
    };
  };

  public shared query ({ caller }) func getUserDataAssets() : async Result.Result<[(Text, Types.DataAssetInfo)], Text> {

    if (Principal.isAnonymous(caller)) {
      return #err("Please log in with a wallet or internet identity.");
    };

    let userID = Map.get(principalIDMap, phash, caller);
    switch (userID) {
      case (?id) {
        let dataAssetMap = Map.get(dataAssetStorage, thash, id);
        switch (dataAssetMap) {
          case (?assetMap) {
            let assetList = Iter.toArray<(Text, Types.DataAsset)>(Map.entries(assetMap));
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
  public shared ({ caller }) func updateDataAsset(timestamp : Text, updatedData : Types.DataAsset) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please login with wallet or internet identity");
    };

    let userID = Map.get(principalIDMap, phash, caller);
    switch (userID) {
      case (?id) {
        let dataAssetMap = Map.get(dataAssetStorage, thash, id);
        switch (dataAssetMap) {
          case (?assetMap) {
            let existingAsset = Map.get(assetMap, thash, timestamp);
            switch (existingAsset) {
              case (?asset) {
                Map.set(assetMap, thash, timestamp, updatedData);
                Map.set(dataAssetStorage, thash, id, assetMap);
                return #ok("Data asset updated successfully");
              };
              case (null) {
                return #err("No data asset found with the provided timestamp");
              };
            };
          };
          case (null) {
            return #err("User has no data assets");
          };
        };
      };
      case (null) {
        return #err("Caller is not a registered user");
      };
    };
  };

  public shared ({ caller }) func grantDataAccess(userID : Text, timestamp : Text) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please login with wallet or internet identity");
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
                let docInAssetMap = Map.get(assetMap, thash, timestamp);
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
      return #err("Please login with wallet or internet identity");
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
      return #err("Please login with wallet or internet identity");
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

  public shared query ({ caller }) func getSharedDataAssets() : async Result.Result<[(Text, Types.DataAssetInfo)], Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please log in with a wallet or internet identity.");
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
                        let dataAsset = Map.get(assetMap, thash, timestamp);
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
      return #err("Please log in with a wallet or internet identity.");
    };

    let userID = Map.get(principalIDMap, phash, caller);
    switch (userID) {
      case (?id) {
        let dataAssetMap = Map.get(dataAssetStorage, thash, id);
        switch (dataAssetMap) {
          case (?assetMap) {
            let assetData = Map.get(assetMap, thash, timestamp);
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
                    Map.set(listings, thash, listingID, newListing);
                    Map.set(userListings, phash, caller, listings);
                  };
                  case (null) {
                    let newListingMap = Map.new<Text, Types.Listing>();
                    Map.set(newListingMap, thash, listingID, newListing);
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
      return #err("Please log in with a wallet or internet identity.");
    };

    let listings = Map.get(userListings, phash, caller);
    switch (listings) {
      case (?listings) {
        let result = Map.remove(listings, thash, listingID);
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

  public query func getAllListings() : async Result.Result<[Types.Listing], Text> {
    if (Map.size(userListings) == 0) {
      return #err("No listings found.");
    };

    let allListings = Buffer.Buffer<Types.Listing>(0);

    for ((user, listings) in Map.entries(userListings)) {
      for (listing in Map.vals(listings)) {
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
      return #err("Please log in with a wallet or internet identity.");
    };

    let listings = Map.get(userListings, phash, caller);
    switch (listings) {
      case (?listings) {
        let userListings = Buffer.Buffer<Types.Listing>(0);
        for (listing in Map.vals(listings)) {
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
      return #err("Please log in with a wallet or internet identity.");
    };

    let buyerID = Map.get(principalIDMap, phash, caller);
    switch (buyerID) {
      case (?buyerID) {
        let seller = Principal.fromText(sellerText);
        let sellerListings = Map.get(userListings, phash, seller);
        switch (sellerListings) {
          case (?listings) {
            let listing = Map.get(listings, thash, listingID);
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

                        let tokenTransferResult = await tokenCanister_api.icrc2_transfer_from({
                          to = {
                            owner = seller;
                            subaccount = null;
                          };
                          from = {
                            owner = caller;
                            subaccount = null;
                          };
                          amount = listing.price * 100000000;
                          fee = ?10000;
                          memo = null;
                          created_at_time = null;
                          spender_subaccount = null;
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

                        let ownerSharedFiles = Map.get(sharedFileList, phash, seller);
                        switch (ownerSharedFiles) {
                          case (?files) {
                            let buff = Buffer.fromArray<Types.sharedActivityInfo>(files);
                            buff.add(sharedInfo);
                            Map.set(sharedFileList, phash, seller, Buffer.toArray(buff));
                          };
                          case (null) {
                            Map.set(sharedFileList, phash, seller, [sharedInfo]);
                          };
                        };

                        let purchasedInformation : Types.purchasedInfo = {
                          title = listing.title;
                          listingID = listingID;
                          price = listing.price;
                          assetID = uniqueID;
                          time = Int.abs(Time.now());
                          seller = sellerID;
                        };

                        let buyerPurchasedList = Map.get(purchasedDataAssetList, phash, caller);
                        switch (buyerPurchasedList) {
                          case (?purchasedList) {
                            let buff = Buffer.fromArray<Types.purchasedInfo>(purchasedList);
                            buff.add(purchasedInformation);
                            Map.set(purchasedDataAssetList, phash, caller, Buffer.toArray(buff));
                          };
                          case (null) {
                            Map.set(purchasedDataAssetList, phash, caller, [purchasedInformation]);
                          };
                        };
                        numberOfTransactions := numberOfTransactions + 1;
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
  public shared query ({ caller }) func getPurchasedDataAssets() : async Result.Result<[(Types.DataAssetInfo, Types.purchasedInfo)], Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please log in with a wallet or internet identity.");
    };

    let purchasedInfoList = Buffer.Buffer<(Types.DataAsset, Types.purchasedInfo)>(0);

    let purchasedList = Map.get(purchasedDataAssetList, phash, caller);
    switch (purchasedList) {
      case (?list) {
        for (purchasedInformation in list.vals()) {
          let parts = Text.split(purchasedInformation.assetID, #text("-"));
          switch (parts.next(), parts.next(), parts.next()) {
            case (?ownerID, ?timestamp, null) {
              let dataAssetMap = Map.get(dataAssetStorage, thash, ownerID);
              switch (dataAssetMap) {
                case (?assetMap) {
                  let dataAsset = Map.get(assetMap, thash, timestamp);
                  switch (dataAsset) {
                    case (?asset) {
                      purchasedInfoList.add((asset, purchasedInformation));
                    };
                    case (null) {};
                  };
                };
                case (null) {};
              };
            };
            case (_) {};
          };
        };
      };
      case (null) {
        return #err("No purchased data assets found for the caller.");
      };
    };

    return #ok(Buffer.toArray(purchasedInfoList));
  };

  public shared ({ caller }) func getAllTokenRequests() : async Result.Result<[(Principal, Types.TokenRequestAmounts)], Text> {
    if (caller != admin) {
      return #err("you are not admin");
    };
    return #ok(Iter.toArray(Map.entries(tokenRequestMap)));
  };

  public shared ({ caller }) func requestForTokens(amount : Nat) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please log in with a wallet or internet identity.");
    };

    let previousStats = Map.get(tokenRequestMap, phash, caller);
    switch (previousStats) {
      case (?stats) {
        let amounts = stats;
        let newAmounts : Types.TokenRequestAmounts = {
          approvedTillNow = amounts.approvedTillNow;
          currentRequestAmount = amount;
        };

        Map.set(tokenRequestMap, phash, caller, newAmounts);
        #ok("Request made sucessfully");
      };
      case (null) {
        let newAmounts : Types.TokenRequestAmounts = {
          approvedTillNow = 0;
          currentRequestAmount = amount;
        };
        Map.set(tokenRequestMap, phash, caller, newAmounts);
        #ok("Request made sucessfully");
      };
    };

  };

  public shared ({ caller }) func requestApproveReject(user : Principal, amount : Nat) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please log in with a wallet or internet identity.");
    };
    if (caller != admin) {
      return #err("you are not admin");
    };

    let previousStats = Map.get(tokenRequestMap, phash, user);
    switch (previousStats) {
      case (?stats) {
        let amounts = stats;
        let newAmounts : Types.TokenRequestAmounts = {
          approvedTillNow = amounts.approvedTillNow + amount;
          currentRequestAmount = 0;
        };

        Map.set(tokenRequestMap, phash, user, newAmounts);
        #ok("Request handled successfully");
      };
      case (null) {

        #err("No request found from that user");
      };
    };
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

  let vetkd_system_api : VETKD_SYSTEM_API = actor ("ck7s6-qyaaa-aaaag-ak43a-cai");

  public func symmetric_key_verification_key() : async Text {
    let { public_key } = await vetkd_system_api.vetkd_public_key({
      canister_id = null;
      derivation_path = Array.make(Text.encodeUtf8("symmetric_key"));
      key_id = { curve = #bls12_381; name = "test_key_1" };
    });
    Hex.encode(Blob.toArray(public_key));
  };

  public shared ({ caller }) func encrypted_symmetric_key_for_caller(encryption_public_key : Blob) : async Text {
    let buf = Buffer.Buffer<Nat8>(32);

    buf.append(Buffer.fromArray(Blob.toArray(Text.encodeUtf8(Principal.toText(caller)))));
    let derivation_id = Blob.fromArray(Buffer.toArray(buf)); // prefix-free

    let { encrypted_key } = await vetkd_system_api.vetkd_encrypted_key({
      derivation_id;
      public_key_derivation_path = Array.make(Text.encodeUtf8("symmetric_key"));
      key_id = { curve = #bls12_381; name = "test_key_1" };
      encryption_public_key;
    });
    Hex.encode(Blob.toArray(encrypted_key));
  };

  public shared ({ caller }) func encrypted_symmetric_key_for_dataAsset(uniqueID : Text, encryption_public_key : Blob) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please log in with a wallet or internet identity.");
    };

    let accessList = Map.get(dataAccessTP, thash, uniqueID);
    switch (accessList) {
      case (?principalList) {
        let found = Array.find<Principal>(principalList, func(p) { p == caller });
        if (found == null) {
          return #err("You don't have access to this data asset.");
        };
      };
      case (null) {
        return #err("Invalid unique ID or data asset not found.");
      };
    };

    let buf = Buffer.Buffer<Nat8>(32);
    buf.append(Buffer.fromArray(Blob.toArray(Text.encodeUtf8(uniqueID))));
    let derivation_id = Blob.fromArray(Buffer.toArray(buf)); // prefix-free

    let { encrypted_key } = await vetkd_system_api.vetkd_encrypted_key({
      derivation_id;
      public_key_derivation_path = Array.make(Text.encodeUtf8("symmetric_key"));
      key_id = { curve = #bls12_381; name = "test_key_1" };
      encryption_public_key;
    });

    #ok(Hex.encode(Blob.toArray(encrypted_key)));
  };

  public shared ({ caller }) func encrypted_symmetric_key_for_user(encryption_public_key : Blob) : async Result.Result<Text, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please log in with a wallet or internet identity.");
    };

    let buf = Buffer.Buffer<Nat8>(32);
    buf.append(Buffer.fromArray(Blob.toArray(Text.encodeUtf8(Principal.toText(caller)))));
    let derivation_id = Blob.fromArray(Buffer.toArray(buf));

    let { encrypted_key } = await vetkd_system_api.vetkd_encrypted_key({
      derivation_id;
      public_key_derivation_path = Array.make(Text.encodeUtf8("symmetric_key"));
      key_id = { curve = #bls12_381; name = "test_key_1" };
      encryption_public_key;
    });

    #ok(Hex.encode(Blob.toArray(encrypted_key)));
  };
  //VetKey Section
  //
  public shared query ({ caller }) func downloadDataAssetData(assetID : Text) : async Result.Result<Blob, Text> {
    if (Principal.isAnonymous(caller)) {
      return #err("Please log in with a wallet or internet identity.");
    };

    let userID = Map.get(principalIDMap, phash, caller);

    switch (userID) {
      case (?id) {
        let sharedAssetIDs = Map.get(dataAccessPT, phash, caller);
        switch (sharedAssetIDs) {
          case (?assetIDs) {
            let found = Array.find<Text>(assetIDs, func(a) { a == assetID });
            if (found != null) {
              let parts = Text.split(assetID, #text("-"));
              switch (parts.next(), parts.next(), parts.next()) {
                case (?ownerID, ?timestamp, null) {

                  let dataAssetMap = Map.get(dataAssetStorage, thash, ownerID);
                  switch (dataAssetMap) {
                    case (?assetMap) {
                      let dataAsset = Map.get(assetMap, thash, timestamp);
                      switch (dataAsset) {
                        case (?asset) {
                          return #ok(asset.data);
                        };
                        case (null) {};
                      };
                    };
                    case (null) {};
                  };

                };
                case (_) {
                  return #err("Invalid assetID format.");
                };
              };
            };
            return #err("You don't have access to the requested data asset.");
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
  //
};
