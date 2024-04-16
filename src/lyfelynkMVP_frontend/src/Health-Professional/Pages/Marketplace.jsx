import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { CardTitle, CardDescription, CardHeader, CardContent, Card } from "@/components/ui/card"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import DataOnSaleTable from "../Tables/DataOnSale"
import DataPurchasedTable from "../Tables/DataPurchased"

export default function MarketplaceContent() {
  return (
    <div>
      <div className="max-w-4xl mx-auto py-12 px-4 sm:px-6 lg:px-8">
        <h1 className="text-4xl font-bold text-foreground">Marketplace</h1>
        <p className="mt-2 text-base text-gray-600">Explore and Acquire Critical Health Insights responsibly.</p>

          <div className="pt-4 pb-10">
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
                    <p className="text-3xl pb-2 font-semibold">2323 LYF Tokens</p>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="allowance">Limit token spending amount</Label>
                    <div className="flex items-center space-x-2">
                      <Input id="allowance" placeholder="Enter allowance" type="number" min="0"/>
                      <Button size="sm">Submit</Button>
                    </div>
                  </div>
                </div>
                <div className="grid grid-cols-1 gap-4 pt-4">
                  <div className="space-y-2">
                    <Label htmlFor="request">Request tokens to be airdropped</Label>
                    <Input id="request" placeholder="Enter amount" type="number" min="0"/>
                  </div>
                  <div className="flex items-end">
                    <Button type="submit">Send request</Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          <Tabs defaultValue="Purchase" className="">
            <TabsList className="w-full">
              <TabsTrigger value="Purchase" className="w-2/3">Purchase</TabsTrigger>
              <TabsTrigger value="Past Orders" className="w-1/3">Past Orders</TabsTrigger>
            </TabsList>

            <TabsContent value="Purchase">
              <DataOnSaleTable/>
            </TabsContent>

            <TabsContent value="Past Orders">
              <DataPurchasedTable/>
            </TabsContent>
          </Tabs>
      </div>
    </div>
  )
}