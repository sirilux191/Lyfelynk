import React from "react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
  DialogClose,
} from "@/components/ui/dialog";
import { ShoppingCart } from "lucide-react";
import { useCanister } from "@connect2ic/react";

export function BuyDataFunc({ listingID, seller }) {
  const [lyfelynkMVP_backend] = useCanister("lyfelynkMVP_backend");

  const handleConfirmPurchase = async () => {
    console.log(listingID);
    console.log(seller);
    try {
      const result = await lyfelynkMVP_backend.purchaseListing(
        listingID,
        seller
      );
      if (result.ok) {
        alert("Purchase successful:", result.ok);
      } else {
        alert("Purchase failed:", result.err);
      }
    } catch (error) {
      alert("Error purchasing listing:", error);
    }
  };

  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button className="p-2 text-white">
          <ShoppingCart />
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Confirm Purchase</DialogTitle>
          <DialogDescription>
            Are you sure you want to buy this data?
          </DialogDescription>
        </DialogHeader>
        <DialogFooter>
          <DialogClose asChild>
            <Button onClick={handleConfirmPurchase}>Yes</Button>
          </DialogClose>
          <DialogClose asChild>
            <Button variant="secondary">Close</Button>
          </DialogClose>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
