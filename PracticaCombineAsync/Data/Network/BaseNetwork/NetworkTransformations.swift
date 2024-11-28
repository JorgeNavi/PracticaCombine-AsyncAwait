import Foundation
import KCLibrarySwift

protocol NetworkTransformationsProtocol {
    func getTransformations(id: String) async -> [TransformationsModel]
}

final class NetworkTransformations: NetworkTransformationsProtocol {
    func getTransformations(id: String) async -> [TransformationsModel] {
        
        var modelReturn = [TransformationsModel]()
        
        let urlString = "\(ConstantsApp.CONST_API_URL)\(EndPoints.transformations.rawValue)"
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = HTTPMethods.post
        request.httpBody = try? JSONEncoder().encode(TransformationsModelRequest(id: id))
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-type")
        
        let JwtToken =  KeyChainKC().loadKC(_: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        if let tokenJWT = JwtToken{
            request.addValue("Bearer \(tokenJWT)", forHTTPHeaderField: "Authorization")
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let resp = response  as? HTTPURLResponse {
                if resp.statusCode == HTTPResponseCodes.SUCCESS {
                    modelReturn = try! JSONDecoder().decode([TransformationsModel].self, from: data)
                }
            }
        } catch {
            
        }
        return modelReturn
    }
}

final class NetworkTransformationsFake: NetworkTransformationsProtocol {
    func getTransformations(id: String) async -> [TransformationsModel] {
        return getTransformationHardcoded()
    }
    
    func getTransformationHardcoded() -> [TransformationsModel] {
        let model1 = TransformationsModel(id: UUID(), name: "1. Oozaru – Gran Mono", description: "Cómo todos los Saiyans con cola, Goku es capaz de convertirse en un mono gigante si mira fijamente a la luna llena. Así es como Goku cuando era un infante liberaba todo su potencial a cambio de perder todo el raciocinio y transformarse en una auténtica bestia. Es por ello que sus amigos optan por cortarle la cola para que no ocurran desgracias, ya que Goku mató a su propio abuelo adoptivo Son Gohan estando en este estado. Después de beber el Agua Ultra Divina, Goku liberó todo su potencial sin necesidad de volver a convertirse en Oozaru", photo: "https://areajugones.sport.es/wp-content/uploads/2021/05/ozarru.jpg.webp")
        
        let model2 = TransformationsModel(id: UUID(), name: "14. Ultra instinto", description: "Realmente no se debería llamar transformación al Ultra Instinto, puesto que es más una técnica que una transformación en sí, pero puesto a que el pelo de Goku se tinta de color blanco o plateado, sí que puede considerarse una nueva transformación, puesto que su apariencia física y su pelo vuelven a cambiar de forma radical al que conocemos como su estado base. Esta transformación la pudimos ver por primera vez en los instantes finales del episodio 129 de Dragon Ball Super, cuando Goku sorprendió a Jiren y a todos los Dioses al ser capaz de dominar este movimiento que sólo los Ángeles parecen capaces de controlar al completo.", photo: "https://areajugones.sport.es/wp-content/uploads/2020/03/goku-ultra-instinto-draogn-ball-fighterz-min.jpg")
        
        return [model1, model2]
    }
}

