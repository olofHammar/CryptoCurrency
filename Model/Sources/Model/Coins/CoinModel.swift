//
//  CoinModel.swift
//  CryptoCurrency
//
//  Created by Olof Hammar on 2023-02-24.
//

import Foundation

public struct CoinModel: Identifiable, Codable, Equatable, Hashable {
    public let id: String
    public let symbol: String
    public let name: String
    public let image: String
    public let currentPrice: Double
    public let marketCap: Double?
    public let marketCapRank: Double?
    public let fullyDilutedValuation: Double?
    public let totalVolume: Double?
    public let high24H: Double?
    public let low24H: Double?
    public let priceChange24H: Double?
    public let priceChangePercentage24H: Double?
    public let marketCapChange24H: Double?
    public let marketCapChangePercentage24H: Double?
    public let circulatingSupply: Double?
    public let totalSupply: Double?
    public let maxSupply: Double?
    public let ath: Double?
    public let athChangePercentage: Double?
    public let athDate: String?
    public let atl: Double?
    public let atlChangePercentage: Double?
    public let atlDate: String?
    public let lastUpdated: String?
    public let sparklineIn7D: SparklineIn7D?
    public let priceChangePercentage24HInCurrency: Double?
    public let currentHoldings: Double?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }

    public func updateHoldings(amount: Double) -> CoinModel {
        return CoinModel(
            id: id,
            symbol: symbol,
            name: name,
            image: image,
            currentPrice: currentPrice,
            marketCap: marketCap,
            marketCapRank: marketCapRank,
            fullyDilutedValuation: fullyDilutedValuation,
            totalVolume: totalVolume,
            high24H: high24H,
            low24H: low24H,
            priceChange24H: priceChange24H,
            priceChangePercentage24H: priceChangePercentage24H,
            marketCapChange24H: marketCapChange24H,
            marketCapChangePercentage24H: marketCapChangePercentage24H,
            circulatingSupply: circulatingSupply,
            totalSupply: totalSupply,
            maxSupply: maxSupply,
            ath: ath,
            athChangePercentage: athChangePercentage,
            athDate: athDate,
            atl: atl,
            atlChangePercentage: atlChangePercentage,
            atlDate: atlDate,
            lastUpdated: lastUpdated,
            sparklineIn7D: sparklineIn7D,
            priceChangePercentage24HInCurrency: priceChange24H,
            currentHoldings: amount
        )
    }

    public var currentHoldingsValue: Double {
        guard let currentHoldings else {
            return 0
        }

        return currentHoldings * currentPrice
    }

    public var rank: Int {
        return Int(marketCapRank ?? 0)
    }

    public static func == (lhs: CoinModel, rhs: CoinModel) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct SparklineIn7D: Codable {
    public let price: [Double]?
}

public extension CoinModel {
    static var mockCoin: CoinModel {
        .init(
            id: "bitcoin",
            symbol: "btc",
            name: "Bitcoin",
            image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
            currentPrice: 248659,
            marketCap: 4801580699885,
            marketCapRank: 1,
            fullyDilutedValuation: 5224367354888,
            totalVolume: 415530254107,
            high24H: 254798,
            low24H: 246761,
            priceChange24H: -5878.924241048662,
            priceChangePercentage24H: -2.30964,
            marketCapChange24H: -111417647387.30957,
            marketCapChangePercentage24H: -2.26781,
            circulatingSupply: 19300556,
            totalSupply: 21000000,
            maxSupply: 21000000,
            ath: 596346,
            athChangePercentage: -58.28369,
            athDate: "2021-11-10T17:30:22.767Z",
            atl: 443.81,
            atlChangePercentage: 55954.60255,
            atlDate: "2013-07-05T00:00:00.000Z",
            lastUpdated: "2023-02-24T09:12:43.500Z",
            sparklineIn7D: .init(
                price:
                    [
                        23729.67910921979,
                        23666.448646465495,
                        23703.093613200122,
                        23678.593817716643,
                        23740.379226044064,
                        23736.204576697633,
                        23786.930235267275,
                        23863.610087653647,
                        23814.44443817983,
                        24095.652474385086,
                        24142.469877098614,
                        24067.364778676645,
                        24330.357197477133,
                        24331.661543019538,
                        24525.93271860235,
                        24783.677812278624,
                        24668.836741008672,
                        24597.1017002252,
                        24628.82455217312,
                        24659.08231684345,
                        24615.8038139379,
                        24566.260577050012,
                        24607.373787840268,
                        24635.531337984372,
                        24626.35166081303,
                        24641.39869550939,
                        24546.551290305506,
                        24565.60529365359,
                        24554.071871374756,
                        24485.68669967891,
                        24513.838369547633,
                        24623.47013567365,
                        24582.52478838142,
                        24695.038684187966,
                        24673.84731568928,
                        24649.21509744199,
                        24646.50380828137,
                        24694.124166222315,
                        24643.997135346468,
                        24605.578244340275,
                        24617.398254219905,
                        24614.831209774173,
                        24635.850030004312,
                        24718.557572152033,
                        24663.438965439873,
                        24671.987911703174,
                        24682.455323172257,
                        24701.586131454587,
                        24715.397269922403,
                        24611.235455459842,
                        24607.19451392114,
                        24584.204216706883,
                        24597.992219855438,
                        24648.182884953752,
                        24680.414225768738,
                        24688.44420706893,
                        24680.35254689371,
                        24722.665259136127,
                        24941.421348504064,
                        24811.629821453404,
                        24575.718476823444,
                        24447.433277864973,
                        24535.41949302992,
                        24517.17315319552,
                        24525.046094321748,
                        24480.53343383269,
                        24322.563258356695,
                        24228.784427258368,
                        24235.936964705368,
                        24330.874982208363,
                        24429.71005966564,
                        24512.16202462863,
                        24462.198957935274,
                        24515.33843564445,
                        24518.962067453507,
                        24453.928970153967,
                        24885.053417947678,
                        24890.781303644144,
                        24916.2005783709,
                        24803.7650001198,
                        24864.151375677426,
                        24972.047000210994,
                        24923.84236428831,
                        24889.483885081165,
                        24868.74306697775,
                        24791.713150868,
                        24843.381417630946,
                        24789.91562720742,
                        24805.166669568982,
                        24694.998348364225,
                        24791.174738128513,
                        24864.2572921906,
                        24865.695679763776,
                        24915.141860952826,
                        24926.181458989326,
                        24886.322731079672,
                        24942.411853832433,
                        24982.455934648817,
                        24977.229588172384,
                        24636.826151076795,
                        24816.16991202087,
                        24705.242314165407,
                        24620.09851332096,
                        24645.83935100631,
                        24645.287313480385,
                        24744.2704888648,
                        24559.63045996503,
                        24425.082151160153,
                        24450.200388320085,
                        24693.172169194302,
                        24597.59208024316,
                        24509.00495071723,
                        24216.199314938425,
                        24370.932550612804,
                        24417.38703630947,
                        24397.397744182686,
                        24267.472839246897,
                        24177.122052813782,
                        24232.301096992152,
                        24155.38913129515,
                        24101.95979580724,
                        23979.689917033713,
                        24076.154678876246,
                        23942.239790735774,
                        24090.95415007665,
                        24169.668962482414,
                        24133.42080011329,
                        24149.09812906485,
                        24130.00537666956,
                        24005.60066033856,
                        23738.790027126597,
                        23688.237675512464,
                        23736.359875852024,
                        23808.36149127166,
                        23790.483047286212,
                        23803.33475956488,
                        23783.255767107872,
                        24090.251960652262,
                        24146.101364545222,
                        24133.35362458213,
                        24180.20245678518,
                        24631.74748429756,
                        24436.836955097122,
                        24451.58460852732,
                        24394.100220000757,
                        24380.946288873587,
                        24369.498250366214,
                        24432.24273136602,
                        24317.629788564882,
                        24271.60002449245,
                        23808.482425910828,
                        23934.47243987676,
                        24024.851566832083,
                        24004.616705290737,
                        23974.33557167891,
                        23849.99341752732,
                        23881.687373192664,
                        23900.041755065267,
                        23970.775585878942,
                        23977.499568739844,
                        23929.513327250857,
                        23807.757150774065,
                        23951.11098423326,
                        23919.482970980607,
                        24021.954249024628,
                        23959.09243868054,
                        23973.59139864187,
                        23949.47472741839
                    ]
            ),
            priceChangePercentage24HInCurrency: -2.3096413330420065,
            currentHoldings: 12
        )
    }

    static var mockCoin2: CoinModel {
        .init(
            id: "dogecoind",
            symbol: "DOG",
            name: "Dogecoin",
            image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
            currentPrice: 248659,
            marketCap: 4801580699885,
            marketCapRank: 1,
            fullyDilutedValuation: 5224367354888,
            totalVolume: 415530254107,
            high24H: 254798,
            low24H: 246761,
            priceChange24H: -5878.924241048662,
            priceChangePercentage24H: -2.30964,
            marketCapChange24H: -111417647387.30957,
            marketCapChangePercentage24H: -2.26781,
            circulatingSupply: 19300556,
            totalSupply: 21000000,
            maxSupply: 21000000,
            ath: 596346,
            athChangePercentage: -58.28369,
            athDate: "2021-11-10T17:30:22.767Z",
            atl: 443.81,
            atlChangePercentage: 55954.60255,
            atlDate: "2013-07-05T00:00:00.000Z",
            lastUpdated: "2023-02-24T09:12:43.500Z",
            sparklineIn7D: .init(
                price:
                    [
                        0.06762999797911882,
                        0.06769883360454379,
                        0.06770792634640309,
                        0.06765566448557676,
                        0.06771629026952468,
                        0.06765338596429026,
                        0.06760532206991388,
                        0.06766945476931831,
                        0.06775096339773942,
                        0.06783787324892222,
                        0.06776029570549555,
                        0.06763730303436329,
                        0.06740463724342947,
                        0.06763107581807125,
                        0.06729730902796459,
                        0.06733764110899805,
                        0.06749053202663963,
                        0.06749468124505004,
                        0.06739496825859574,
                        0.06707600011247954,
                        0.06701314032766324,
                        0.06708300276372683,
                        0.06704354335226875,
                        0.06707420715517226,
                        0.06707717041337613,
                        0.06699189137323404,
                        0.06715653084627354,
                        0.06738295811510837,
                        0.06735920974095941,
                        0.06763051738731136,
                        0.06753993496310724,
                        0.06759194161678082,
                        0.06773533981731719,
                        0.0678014712316413,
                        0.06745674917850013,
                        0.06742981628673198,
                        0.06741044839643857,
                        0.06751115149356554,
                        0.06778880901958033,
                        0.0675590798140417,
                        0.0674373468255955,
                        0.06739999943661418,
                        0.06744493677693805,
                        0.06738778730504592,
                        0.06737728140505955,
                        0.06737010303260008,
                        0.0672831832700977,
                        0.06712599254777715,
                        0.0670228077215775,
                        0.0669464361474308,
                        0.06700644356135799,
                        0.06711890844265431,
                        0.06724640741461627,
                        0.06703406567743808,
                        0.06628773123151253,
                        0.0666791137700797,
                        0.06652126879276879,
                        0.06656905853057729,
                        0.06627376354943647,
                        0.06630329155715171,
                        0.06605345842772667,
                        0.06641503518245229,
                        0.06667180110009513,
                        0.06629087672500539,
                        0.06643896771196606,
                        0.0663994237672963,
                        0.06657414173740044,
                        0.06608642872373482,
                        0.06642218655516874,
                        0.06645809912564497,
                        0.06619547615519152,
                        0.0663314199291908,
                        0.06646070362937687,
                        0.06622807640801964,
                        0.06622449079006028,
                        0.06596343768713742,
                        0.06571792238502079,
                        0.06619315906130886,
                        0.06617635328639826,
                        0.06606214802775885,
                        0.06584639722171279,
                        0.06589853667125645,
                        0.06605831174408805,
                        0.06580580042847033,
                        0.06543263184226651,
                        0.06535643263770381,
                        0.06511730589496394,
                        0.06530865508826399,
                        0.06571291403048496,
                        0.06589487174418085,
                        0.06585041573303488,
                        0.06596746626944563,
                        0.0660299842677406,
                        0.06568457078230973,
                        0.06591938829703163,
                        0.06591168232253715,
                        0.06595607883351902,
                        0.0660987508411544,
                        0.06607126591824533,
                        0.0662125877209601,
                        0.06622050173662193,
                        0.06611254135783719,
                        0.06601735595177369,
                        0.06600444023679768,
                        0.0655318694427545,
                        0.06504656627836525,
                        0.06329295735206598,
                        0.05775074617923905,
                        0.0584453078127665,
                        0.05870343622849263,
                        0.05800825617495667,
                        0.05852966678722363,
                        0.0582454928648134,
                        0.05819835278092136,
                        0.05834604670756525,
                        0.05812218884278196,
                        0.05743890940420745,
                        0.05762458505813212,
                        0.05760544886574311,
                        0.05665330316048143,
                        0.05590184460367032,
                        0.05611315857393658,
                        0.05681283001305228,
                        0.05719823487534595,
                        0.05654284340573733,
                        0.05702262311400086,
                        0.0570848123149088,
                        0.057068180434158046,
                        0.05660302120735992,
                        0.056853660891973655,
                        0.05707528493666634,
                        0.05668276980603247,
                        0.057295346039090964,
                        0.05742506546659939,
                        0.057723251610565664,
                        0.05817202497392053,
                        0.057771097391850525,
                        0.05734230295239219,
                        0.05683525668578977,
                        0.05711588427267654,
                        0.05680355388685805,
                        0.05516342897882549,
                        0.05595101612435538,
                        0.056155131456696,
                        0.05595479338666751,
                        0.05596114695027218,
                        0.05593705268004358,
                        0.05599294592621298,
                        0.05599483025832311,
                        0.05579132385065075,
                        0.05626630992690988,
                        0.05690775810915731,
                        0.05741265465914988,
                        0.05823364681200124,
                        0.05864001595743485,
                        0.0586799382221556,
                        0.05859650851533049,
                        0.05907023116692933,
                        0.0588401182902875,
                        0.05884920131232405,
                        0.05875411424523499,
                        0.058939241759163985,
                        0.05889657659829379,
                        0.05908366004326503,
                        0.05905879244318028,
                        0.05893701786641257,
                        0.05899609660640272,
                        0.058924647202406435,
                        0.05907111567135237
                    ]
            ),
            priceChangePercentage24HInCurrency: -2.3096413330420065,
            currentHoldings: 12
        )
    }
}
