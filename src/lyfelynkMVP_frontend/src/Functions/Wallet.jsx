import React, { useState } from "react";
import { useCanister } from "@connect2ic/react";
import { Principal } from "@dfinity/principal";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";

export default function Wallet() {
  const [icrc1_ledger_canister] = useCanister("icrc1_ledger_canister");
  const [lyfelynkMVP_backend] = useCanister("lyfelynkMVP_backend");
  const [approveAmount, setApproveAmount] = useState();
  const [allowanceValue, setAllowanceValue] = useState(0);
  const [balance, setBalance] = useState(0);
  const [requestAmount, setRequestAmount] = useState(0);

  const approveSpendToken = async () => {
    const approveArugument = {
      fee: [],
      memo: [],
      from_subaccount: [],
      created_at_time: [],
      amount: approveAmount * 100000000,
      expected_allowance: [],
      expires_at: [],
      spender: {
        owner: Principal.fromText("cn6uk-5aaaa-aaaag-ak43q-cai"),
        subaccount: [],
      },
    };
    const result = await icrc1_ledger_canister.icrc2_approve(approveArugument);

    Object.keys(result).forEach((key) => {
      if (key === "Err") {
        console.error(result[key]);
      }
      if (key === "Ok") {
        alert("Allowed to spend token");
      }
    });
  };

  const getAllowance = async () => {
    const principal = await lyfelynkMVP_backend.whoami();
    console.log(principal);
    const allowanceArgument = {
      account: {
        owner: Principal.fromText(principal),
        subaccount: [],
      },
      spender: {
        owner: Principal.fromText("cn6uk-5aaaa-aaaag-ak43q-cai"),
        subaccount: [],
      },
    };
    let result = await icrc1_ledger_canister.icrc2_allowance(allowanceArgument);

    if (typeof result.allowance == "bigint") {
      setAllowanceValue(Number(result.allowance) / 100000000);
    } else {
      console.error(result.err);
    }
  };

  const getBalance = async () => {
    const principal = await lyfelynkMVP_backend.whoami();
    console.log(principal);
    const result = await icrc1_ledger_canister.icrc1_balance_of({
      owner: Principal.fromText(principal),
      subaccount: [],
    });
    setBalance(Number(result) / 100000000);
  };

  const sendTokenRequest = async () => {
    const result = await lyfelynkMVP_backend.requestForTokens(requestAmount);
    Object.keys(result).forEach((key) => {
      if (key === "err") {
        console.error(result[key]);
      }
      if (key === "ok") {
        alert(result[key]);
      }
    });
  };

  return (
    <Card className="w-full bg-transparent border-2 border-gray-600">
      <CardHeader>
        <CardTitle>Wallet</CardTitle>
        <CardDescription>Manage your token allowances.</CardDescription>
      </CardHeader>
      <div className="border border-gray-600 mb-4 "></div>
      <CardContent>
        <div className="md:grid grid-cols-2 gap-4">
          <div className="space-y-2 pb-2">
            <Label>Current allowance</Label>
            <p className="text-3xl pb-2 font-semibold">
              {allowanceValue} LYF Tokens
            </p>
            <Button
              size="sm"
              type="submit"
              variant="outline"
              onClick={getAllowance}
            >
              Update Current Allowance Amount
            </Button>
          </div>

          <div className="space-y-2 pb-2">
            <Label>Your Balance</Label>
            <p className="text-3xl pb-2 font-semibold">
              {balance} LYF Tokens
            </p>
            <div className="flex items-end">
              <Button
                size="sm"
                type="submit"
                variant="outline"
                onClick={getBalance}
              >
                Update Current Balance Amount
              </Button>
            </div>
          </div>

        </div>

        <div className="grid grid-cols-2 gap-4 pt-4">
          <div className="space-y-2">
            <Label htmlFor="allowance">Limit token spending amount</Label>
            <Input
              id="allowance"
              placeholder="Enter allowance"
              type="number"
              min="0"
              value={approveAmount}
              onChange={(e) => setApproveAmount(e.target.value)}
            />
            <Button
              size="sm"
              type="submit"
              onClick={approveSpendToken}
            >
              Submit
            </Button>
          </div>
          
          <div className="space-y-2">
            <Label htmlFor="request">
              Request tokens to be airdropped
            </Label>
            <Input
              id="request"
              placeholder="Enter amount"
              type="number"
              min="0"
              value={requestAmount}
              onChange={(e) => setRequestAmount(e.target.value)}
            />
            <div className="flex items-end">
              <Button
                type="submit"
                onClick={sendTokenRequest}
              >
                Send request
              </Button>
            </div>
          </div>

        </div>
      </CardContent>
    </Card>
  );
}
