import GoogleGenerativeAI
import Foundation

class LLMUtilitis
{
    public static func cleanUpTheJSONString(JSONString: String) -> String
    {
        var str = JSONString
        str.replace("´´´", with: "")
        str.replace("json\n", with: "")
        str.replace("```", with: "")
        str.replace("\\'", with: "'")
        return str
    }
    
    public static func fixIncompleteJSON(JSONString: String) -> String
    {
        let decoder = JSONDecoder()
        let JSONString_fixed1 = JSONString + "}"
        
        do {
            if let JSONData_1 = JSONString_fixed1.data(using: .utf8) {
                let _ = try decoder.decode(Response.self, from: JSONData_1)
                return JSONString_fixed1
            }
        } catch {
            do {
                let JSONString_fixed2 = JSONString + "]}"
                if let JSONData_2 = JSONString_fixed2.data(using: .utf8) {
                    let _ = try decoder.decode(Response.self, from: JSONData_2)
                    return JSONString_fixed2
                }
            } catch {
                do {
                    let JSONString_fixed3 = JSONString + "}]}"
                    if let JSONData_3 = JSONString_fixed3.data(using: .utf8) {
                        let _ = try decoder.decode(Response.self, from: JSONData_3)
                        return JSONString_fixed3
                    }
                } catch {
                    do {
                        let JSONString_fixed4 = JSONString + "\\\"}]}"
                        if let JSONData_4 = JSONString_fixed4.data(using: .utf8) {
                            let _ = try decoder.decode(Response.self, from: JSONData_4)
                            return JSONString_fixed4
                        }
                    } catch {
                        return JSONString
                    }
                }
            }
        }
        return JSONString
    }
}
