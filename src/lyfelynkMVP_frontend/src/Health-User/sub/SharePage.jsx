import { ChevronLeft } from "lucide-react"
import { Link } from "react-router-dom"
import { ShareSellTable } from "../Tables/ShareSellData"

export default function ShareContent() {
  return (
    <div>
      <div className="flex flex-col items-center justify-center p-8">
          <div className="flex items-center justify-between w-full">
            <Link to="/Health-User/MyHealth">
              <div className="flex text-gray-600">
                <ChevronLeft className=" mr-2" />
                Back
              </div>
            </Link>
          </div>
        <h1 className="mt-4 text-4xl font-bold">Share your Health Data</h1>
        <p className="mt-2 text-lg text-gray-600">Choose the documents below to share or sell the data.</p>

        <div className="mt-4 w-full max-w-2xl">
          <ShareSellTable/>
        </div>

      </div>
    </div>
  )
}