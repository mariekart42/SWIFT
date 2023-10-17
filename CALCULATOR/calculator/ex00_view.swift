
import SwiftUI

struct ContentViewEx00: View
{
    var body: some View
    {
//		Button(action: {
//			print("ehh someone touched me")
//		}, label: {
//			/*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
//		})
		
// both do the same thing!
		
		Button(action: {
			print("ehh someone touched me")
		}){
			/*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
		}
    }
}

