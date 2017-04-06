//
//  RegistDelegateViewController.m
//  CYZhongBao
//
//  Created by cbwl on 16/5/1.
//  Copyright © 2016年 xc. All rights reserved.
//

#import "RegistDelegateViewController.h"
#import "PublicSouurce.h"

@interface RegistDelegateViewController ()

{
    UIScrollView *scrollview;
    float _lbl_height;
}

@property (nonatomic, strong) UIView *titleView;//标题view
@property (nonatomic, strong) UILabel *titleLabel;//标题

@end

@implementation RegistDelegateViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=false;
//    self.hidesBottomBarWhenPushed=NO;
    self.tabBarController.tabBar.hidden=YES;

    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lbl_height=0;
    self.view.backgroundColor = [UIColor whiteColor];
    //添加头部菜单栏
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, 0, 200, 36)];
        _titleView.backgroundColor = [UIColor clearColor];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 200, 36)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = TextMainCOLOR;
        _titleLabel.text = @"邦办雇主商户注册协议";
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleView addSubview:_titleLabel];
    }
    self.navigationItem.titleView = _titleView;
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0, 0, 30, 30);
    [leftItem setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    
    scrollview = [[UIScrollView alloc]init];
//    scrollview.frame = self.view.bounds;
    scrollview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 3400);
//    if (SCREEN_HEIGHT == 667)
//    {
//        scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 5700-667*2-480);
//    }
//    if(SCREEN_HEIGHT == 736)
//    {
//        scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 5200-756*2-480);
//    }
    
    [self.view addSubview:scrollview];
    
    NSString *A = @"邦办即达商户平台所提供的各项服务的所有权和运营权，均归属于南京邦办网络科技有限公司。注册协议（以下简称“本协议”）系商户因使用邦办即达商户平台的各项服务而与邦办即达商户平台订立的正式的、完整的协议。商户在邦办即达商户平台注册，即表示接受本协议的所有条件和条款。商户部分或全部不接受本协议条款的，不得使用邦办即达商户平台。";
    NSString *B = @"本协议内容同时包括邦办即达商户平台可能不断发布或更新的相关协议、业务规则等内容。上述内容一经正式发布，即为本协议不可分割的组成部分。";
    NSString *C = @"商户与邦办即达商户平台签订的书面合同与本协议不一致的，以书面合同为准。";
    NSString *D = @"第1条 定义";
    
    NSString * E = @"1.1 邦办即达商户平台，是包括但不限于域名为“为www.bangbanjida.com”的Web站点和名称为“邦办即达商家”的应用的合称，是为商户提供账户信息管理，配送信息发布与查询、配送交易撮合与处理、订单查询与管理、定价建议与咨询、代理配送费磋商与谈判、配送费用代收代垫与代付、争议调解等互联网信息服务和在线交易处理服务的网络平台。邦办即达商户平台并不直接参与商户与用户之间的配送交易，双方因配送合同履行发生争议的，应当根据合同相对性原则自行协商处理或寻求邦办即达商户平台调解争议。\n1.2 用户，是指邦办即达商户平台的配送服务的实际承运人。";
    NSString * F = @"1.3 商户，是指在邦办即达商家平台发布配送服务需求的，在邦办即达配送平台显示为配送订单需求方的，具有向货物接受人销售配送货物的个人、组织或机构。本协议项下，特指已经登录或下载邦办即达商户平台，并自愿申请注册，且具有销售配送货物的条件和资质的商户。商户应当根据邦办即达商户平台业务规则及订单信息，向依约完成配送订单的用户支付报酬。";
    NSString * G = @"1.4 配送订单，是指商户通过邦办即达商家平台发布的，在邦办即达配送平台显示的配送服务要约信息（包括但不限于商户信息、配送货物、配送地址、收货人信息及配送费用等），用户一旦通过点击或确认的方式承诺配送订单的，配送合同即为生效。订单作为用户与商户的配送合同，是双方权利义务的证明文件；双方线下达成交易条件（例如代收货款、附条件配送等）的，各自自行保留相应的证据。";
    NSString * H = @"第2条 服务条款的确认和接受";
    NSString * I = @"2.1 商户应在使用邦办即达商户平台的服务之前认真阅读本协议及相关业务规则内容。如对协议有任何疑问的，应向邦办即达商户平台客服咨询。但无论商户事实上是否在使用邦办即达商户平台的服务之前认真阅读了本协议内容，只要商户使用邦办即达商户平台的服务，则本协议即对商户产生约束，届时商户不应以未阅读本协议的内容或者未获得邦办即达商户平台客服对问询的解答等理由，主张本协议无效，或要求撤销本协议。";
    NSString * J = @"2.2 商户必须完全同意所有服务条款并完成注册程序，才能成为邦办即达商户平台的注册商户。在商户按照注册页面提示填写信息、阅读并同意本协议并完成全部注册程序后，或以邦办即达商户平台允许的其他方式实际使用邦办即达商户平台的服务时，商户即受本协议的约束。";
    NSString * K = @"2.3 商户须确认，在完成注册程序或以邦办即达商户平台允许的其他方式实际使用邦办即达商户平台的服务时，应当是具备完全民事行为能力和责任能力的自然人、法人或其他法律确定的组织或机构。如果不具备前述主体资格，邦办即达商户平台有权中止或注销该商户的账户。";
    NSString * L = @"2.4 商户应当保证注册时提供的信息和资质的完整性、真实性、合法性。邦办即达商户平台有权根据业务需要，不时审核商户的注册信息及提供的资质是否完整真实有效，一旦发现商户信息和资质不符合邦办即达商户平台业务规则的，邦办即达商户平台有权中止或注销该商户。";
    NSString * M =@"2.5 商户承诺有条件、有资质向收货人销售配送订单约定的配送货物，配送货物涉及国家专营或依审批从事的业务时，商户必须取得相应的全部审批文件及备案资质。订单一经用户抢单确认，商户即不可撤销订单；用户如约完成订单的，商户应当支付相应的配送费。邦办即达商户平台有权根据业务规则采取扣款、罚款、中止订单发布资格、注销账户等方式处罚商户的履约瑕疵行为。\n2.6 根据业务需要，邦办即达商户平台保留在国家法律允许的范围内，独自决定拒绝服务、中止服务、终止服务或注销商户账户的权利。\n2.7 根据业务需要，邦办即达商户平台保留在国家法律允许的范围内，不时地制订、修改本协议或业务规则，并以网站或者手机APP公示的方式进行公示。如商户继续使用邦办即达商户平台的服务的，即表示商户接受经修订的协议和规则。\n2.8 为了保证邦办即达商户平台服务的安全性和功能的一致性，邦办即达商户平台有权不经向商户特别通知而对应用进行更新，或者对邦办即达商户平台的部分功能效果进行改变或限制。新版本发布后，旧版本的邦办即达商户平台可能无法使用。邦办即达商户平台不保证旧版本继续可用及相应的客户服务，商户应随时核对并下载最新版本。\n2.9 商户使用邦办即达商户平台提供的API接口的，除非书面合同有相反的约定，应当遵守本协议。";
    NSString * N =@"第3条 平台服务内容";
    NSString * O =@"3.1 邦办即达商户平台可能为不同的终端设备开发了不同的应用程序版本，商户应当根据实际情况选择下载合适的版本进行安装。邦办即达商户平台不保证所有的版本与相关设备的适配性和可用性，亦不保证所有的版本提供的服务的一致性。\n3.2 邦办即达商户平台提供的服务为：提供账户信息管理，配送信息发布与查询、配送交易撮合与处理、订单查询与管理、定价建议与咨询、代理配送费磋商与谈判、配送费用代收代垫与代付、争议调解等互联网信息服务和在线交易处理服务。具体以邦办即达商户平台届时有效的服务内容为准。\n3.3 尽管邦办即达商户平台尽力保证服务的有效性和可用性，但因电信故障、黑客攻击或政策变动等因素，可能导致前述服务部分或全部无效或调整，商户理解并接受该等情形的出现，并放弃因此向邦办即达商户平台索赔的权利。\n3.4 商户必须自行准备如下服务设备，并承担相关服务开支：\n（1）服务设备，包括并不限于手机、电脑或者其他移动终端、调制解调器及其他必备的上网装置。\n（2）服务开支，包括并不限于网络接入费、上网设备租用费、网络带宽或流量费、配送费用、结算手续费，以及履行配送服务过程可能发生的其他费用等。\n3.5 商户通过邦办即达商户平台预付或后付配送费的，相关合同、充值、扣款、发票及凭证索取等规则，参照邦办即达商户平台届时有效的规则执行；商户与邦办即达商户平台达成其他书面协议的，相关权利义务参照具体协议。\n3.6 商户使用邦办即达商户平台服务而需要下载相关客户端程序时，邦办即达商户平台给予商户一项单个的、不可转让及非排他性的许可。商户仅在使用邦办即达商户平台服务时使用相关客户端程序，不进行反向工程、反向汇编、反向编译，或者以其他方式尝试发现相关客户端程序的源代码；不得删除相关客户端程序及其副本上关于著作权的信息。商户终止使用邦办即达商户平台服务时，应当立即删除相关客户端程序及其数据。\n3.7 本条及本协议其他条款未明示授权的其他一切权利仍由邦办即达商户平台保留，商户在行使这些权利时须另外取得邦办即达商户平台的书面许可。邦办即达商户平台如果未行使前述任何权利，并不构成对该权利的放弃。";
    NSString * P =@"第4条 账户管理";
    NSString * Q =@"4.1 商户账户的所有权归邦办即达商户平台所有，商户完成申请注册手续后，仅获得商户帐号的使用权，且该使用权仅属于初始申请注册人。\n4.2 商户注册成功后，将生成由商户自行设置的商户名称、发货地址、手机号码和管理密码等账户信息。商户可以根据邦办即达商户平台的业务规则改变密码。商户应谨慎合理的保存、使用其商户名和密码，并对利用商户的商户名和密码完成管理权限验证而实施的所有行为、活动及事件负全责。商户若发现任何不当使用商户账号或存在安全漏洞等其他可能危及商户账户安全的情况，应当立即以有效方式通知邦办即达商户平台，要求邦办即达商户平台暂停相关服务，并向公安机关报案。\n4.3 商户依据4.2条发出的通知至少应当包括情况描述，相关的初步证据，要求邦办即达商户平台处理措施，通知人联系信息等，缺乏前述信息的通知视为无效通知。商户理解邦办即达商户平台对商户的通知请求识别、采取行动需要合理时间，邦办即达商户平台对在采取行动前已经产生的后果（包括但不限于商户的任何损失）不承担任何责任。\n4.4 商户不得将账户借/租给他人使用，否则商户应承担由此产生的全部责任，并与实际使用人承担连带责任。一经发现，邦办即达商户平台有权注销此等账户。因此涉嫌牌照借用或租用而违反国家法律法规规定的，邦办即达商户平台有权向国家司法机关举报。\n4.5 商户理解并同意，为了更好的为商户提供服务，邦办即达商户平台及其关联方可以无偿的、商业性的分析和使用商户注册信息及使用数据。但邦办即达商户平台不得将该等信息或数据泄露给商户的竞争对手，亦不得利用该等信息或数据从事与商户相竞争的业务。\n4.6 商户注册帐号后如果长期不登录该帐号，邦办即达商户平台有权回收、注销该帐号，以免造成资源浪费，由此带来的任何损失均由商户自行承担。\n4.7 商户理解并同意，邦办即达商户平台通过向商户注册时预留的地址、电话、邮箱等任一方式发送信息，或者通过邦办即达商户平台发送站内信息，即视为邦办即达商户平台向商户履行了送达、通知义务。";
    NSString * R =@"第5条 责任范围与责任限制（重要）";
    NSString * S =@"5.1 商户理解并同意，商户委托的配送服务的合同相对方是用户，合同履行的瑕疵担保及付款责任应当由用户根据约定内容承担，作为交易信息平台的邦办即达商户平台，与用户无劳动、雇佣或合作关系，不向用户承担任何担保或连带责任。\n5.2 商户在交付配送货物之前，应当自行审核用户的真实性及履约能力，有义务验明用户的真实身份信息，要求用户提供履约担保。特别地，邦办即达商户平台作为交易信息平台，无法控制每一用户配送质量、效率或合法性。\n5.3 商户应当向用户明示配送货物的性质和品类，配送注意事项，以及货物接收人的信息；因商户故意隐瞒或遗漏相关信息而使用户或第三方遭受人身损害、财产损害的，商户应当依法承担相应的法律责任，邦办即达商户平台因此遭受损失的，有权向商户追偿。\n5.4 商户与用户达成配送订单信息以外的线下交易或条件（例如代收货款、附条件配送等）的，商户应当自行保留相应的证据，并在各自责任范围内承担相应的法律责任。任何时候，商户禁止向用户委托配送下列货物：\n（1）国家法律法规禁止配送的；\n（2）国家法律法规要求特殊资质或条件配送的。\n5.5 有且仅当法律法规明确要求，或出现以下情况，邦办即达商户平台才对商户及用注册信息、配送订单信息进行事先或事后的审查：\n（1）应商户或用户要求的，且有合理的理由认为特定商户、用户或交易可能存在重大违法或违约情形。\n（2）应商户或用户要求的，且有合理的理由认为商户、用户在邦办即达商户平台的行为涉嫌违法或不当。\n商户理解并同意，受限于数据及技术条件，邦办即达商户平台的前述审查行为无法做到完全审查。\n5.6 商户理解并同意，依据法律或本协议有明确的赔偿义务的前提下，邦办即达商户平台的赔偿限额为单笔配送订单的货物价格（价格高于RMB500元的，商户应当与邦办即达商户平台签订书面合同），且不对因下述情况而导致的任何损害赔偿承担责任，包括但不限于利润、商誉、使用、数据等方面的损失或其它无形损失的损害赔偿：\n（1）使用或未能使用邦办即达商户平台的服务；\n（2）第三方未经批准地使用或更改商户的数据；\n（3）通过邦办即达商户平台的服务购买或获取任何商品、样品、数据、信息等行为或替代行为产生的费用及损失；\n（4）商户对邦办即达商户平台的服务的误解；\n（5）任何非因邦办即达商户平台的过错原因而引起的与邦办即达商户平台的服务有关的其它损失。\n5.7 如因不可抗力或邦办即达商户平台无法控制的其他原因使邦办即达商户平台系统崩溃或无法正常使用，从而导致配送交易无法完成或丢失有关的信息、记录等，邦办即达商户平台不承担责任。邦办即达商户平台会尽可能合理地协助处理善后事宜，并努力使商户免受或减少经济损失。\n5.8 商户同意在发现邦办即达商户平台任何内容不符合法律规定，或不符合本协议规定的，或用户信息虚假的，有义务及时通知邦办即达商户平台。如果商户发现合法权利受到侵害，请将此情况告知邦办即达商户平台并同时提供如下信息和材料：\n（1）侵犯商户权利的信息的网址，编号或其他可以找到该信息的细节；\n（2）商户的联系方式，包括联系人姓名，地址，电话号码和电子邮件；\n（3）商户的身份证复印件、营业执照等其他相关资料。\n 经审查得到证实的，邦办即达商户平台将及时删除相关信息。邦办即达商户平台仅接受邮寄、电子邮件或传真方式的书面侵权通知。情况紧急的，商户可以通过客服电话先行告知，邦办即达商户平台会视情况采取相应措施。\n5.9 商户应当严格遵守本协议及邦办即达商户平台发布的其他协议、活动规则，因商户违反协议或规则的行为给第三方或邦办即达商户平台造成损失的，商户应当承担全部责任，邦办即达商户平台因此承担责任的，有权向商户追偿。\n5.10 商户理解并同意，邦办即达商户平台可能会与第三方合作向商户提供相关的服务（包括但不限于广告服务、支付服务、寻址定位服务等），在此情况下，邦办即达商户平台不保证该第三方提供的服务的可用性、有效性和合法性。";
    NSString * T =@"第6条 对商户信息的存储和限制";
    NSString * U =@"6.1 邦办即达商户平台不对商户所发布信息的删除或储存失败、遗失负责，商户应当自行备份商户信息及使用数据。\n6.2 商户账户被注销后，邦办即达商户平台没有义务为其保留或向其披露其账户中的任何信息，也没有义务向商户或第三方转发任何商户未曾阅读或发送过的信息。\n6.3 商户理解并同意，与邦办即达商户平台的协议关系终止后，邦办即达商户平台仍享有下列权利：\n（1）继续保存商户未及时删除的注册信息及使用邦办即达商户平台的服务期间发布的所有信息的权利，直至法律规定的记录保存期满。\n（2）商户在使用邦办即达商户平台的服务期间存在违法行为或违反本协议和/或规则的行为的，邦办即达商户平台仍可依据本协议向商户主张权利。\n（3）要求商户根据本协议承担保密义务而无需支付任何费用的权利。\n 第7条 信息与数据所有权\n7.1 邦办即达商户平台各项信息服务及其载体，以及交易处理数据的所有权和运营权归邦办即达商户平台，邦办即达商户平台得依自身义务需要采取任何商业性利用或开发。\n7.2 邦办即达商户平台服务内容包括：文字、软件、声音、图片、录像、图表、广告中的全部内容，电子邮件的全部内容，邦办即达商户平台为商户提供的其他信息。所有这些内容受版权、商标、标签和其它财产权法律的保护。所以，商户只能在邦办即达商户平台和广告商授权下才能使用这些内容，而不能擅自复制、再造这些内容、或创造与内容有关的派生产品。邦办即达商户平台所有的文章版权归原文作者和邦办即达商户平台共同所有，任何人需要转载该等文章或信息，必须征得原文作者或邦办即达商户平台授权。\n7.3 商户接受本协议条款，即表明该商户将其在邦办即达商户平台发表的任何形式的信息的著作权或其他合法权利，包括并不限于：复制权、发行权、出租权、展览权、表演权、放映权、广播权、信息网络传播权、摄制权、改编权、翻译权、汇编权以及应当由著作权人享有的其他可转让权利无偿独家转让给邦办即达商户平台所有，同时表明该商户许可邦办即达商户平台有权就任何主体侵权而单独提起诉讼，并获得全部赔偿。本协议效力及于商户在邦办即达商户平台发布的任何受著作权法保护的作品内容，无论该内容形成于本协议签订前还是本协议签订后。同时，邦办即达商户平台保留删除站内各类不符合规定的信息而不通知商户的权利。";
    
    NSString * V = @"第8条 商户行为规范";
    NSString * W = @"8.1 商户须严格按照邦办即达商户平台提供、发布、更新的服务条款和业务规则执行。邦办即达商户平台不时发布的成文或非成文的业务规则，以及既成的交易模式或惯例，视为本协议的重要组成部分。\n8.2 在使用邦办即达商户平台服务过程中，商户承诺遵守以下约定：\n（1）在使用邦办即达商户平台的服务过程中实施的所有行为均遵守国家法律、法规等规范文件及邦办即达商户平台的各项规则的规定和要求，不违背社会公共利益或公共道德，不损害他人的合法权益，不违反本协议及相关规则。如果违反前述承诺，产生任何法律后果的，商户应以自己的名义独立承担所有的法律责任，并确保邦办即达商户平台免于因此产生任何损失。\n（2）不发布国家禁止发布的信息（除非取得合法且足够的许可），不发布涉嫌侵犯他人知识产权或其它合法权益的信息，不发布违背社会公共利益或公共道德、公序良俗的信息，不发布其它涉嫌违法或违反本协议及各类规则的信息。\n（3）不对邦办即达商户平台上的任何数据或信息作商业性利用，包括但不限于在未经邦办即达商户平台事先书面同意的情况下，以复制、传播等任何方式使用，或许可、泄露给任何第三方使用，或者为任何第三方使用提供便利，该等责任及于商户与邦办即达配送服务平台服务关系终止后三年。\n（4）不使用任何装置、软件或例行程序干预或试图干预邦办即达商户平台的正常运作或正在邦办即达商户平台上进行的任何活动。商户不得采取任何将导致不合理的庞大数据负载加诸邦办即达商户平台网络设备的行动。\n（5）不得发表、传送、传播、储存侵害他人知识产权、商业秘密权等合法权利的内容或包含病毒、木马、定时炸弹等可能对邦办即达服务系统造成伤害或影响其稳定性的内容。\n（6）不得进行危害计算机网络安全的行为，包括但不限于：使用未经许可的数据或进入未经许可的服务器帐号；不得未经允许进入公众计算机网络或者他人计算机系统并删除、修改、增加存储信息；不得未经许可，企图探查、扫描、测试本平台系统或网络的弱点或其它实施破坏网络安全的行为；不得企图干涉、破坏本平台系统或手机APP的正常运行。\n（7）不得发布任何有损邦办即达商户平台商誉的言论。\n8.3 商户理解并同意：\n（1）违反上述承诺时，邦办即达商户平台有权依据本协议的约定，做出相应处理或终止提供服务，且无须征得商户的同意或提前通知商户。\n（2）根据相关法令的指定或者邦办即达商户平台服务规则的判断，商户的行为涉嫌违反法律法规的规定或违反本协议和/或规则的条款的，邦办即达商户平台有权采取相应措施，包括但不限于罚款、暂扣款项、直接屏蔽、删除侵权信息、降低信用值或直接停止提供服务，直至注销账户。\n（3）对于商户在邦办即达商户平台上实施的行为，包括未在邦办即达商户平台上实施但已经对邦办即达商户平台及其商户产生影响的行为，邦办即达商户平台有权单方认定该行为的性质及是否构成对本协议和/或规则的违反，并据此采取相应的必要的处理措施。\n（4）对于商户涉嫌违反承诺的行为对任意第三方造成损害的，商户均应当以自己的名义独立承担所有的法律责任，并应确保邦办即达商户平台免于承担因此产生的损失或增加的费用。\n（5）如商户涉嫌违反有关法律或者本协议之规定，使邦办即达商户平台遭受任何损失，或受到任何第三方的索赔，或受到任何行政管理部门的处罚，商户应当赔偿邦办即达商户平台因此造成的损失及发生的费用，包括合理的律师费用。\n8.4 商户因使用邦办即达商户平台而获取的收益，应当自行依法缴纳相关税费。";
    NSString * X = @"第9条 法律管辖和适用";
    NSString * Y = @"9.1 本条款的订立、执行和解释及争议的解决均应适用中国法律。\n9.2 本协议签订地为中华人民共和国上海市浦东新区。\n9.3 如双方就本条款内容或其执行发生任何争议，双方应尽力友好协商解决；协商不成时，任何一方均可向邦办即达商户平台所在地的人民法院提起诉讼。\n9.4本协议所有条款的标题仅为阅读方便，本身并无实际涵义，不能作为本协议涵义解释的依据。\n9.5本协议条款无论因何种原因部分无效或不可执行，其余条款仍有效，对双方具有约束力。";
   
    UILabel *a =[[UILabel alloc]init];
    a.frame = CGRectMake(10,10, SCREEN_WIDTH-20,[self rectWithStr:A]);
    a.text =A;
    [self WithLabel:a];
    
    UILabel *b =[[UILabel alloc]init];
    [self floatWithLabel:b WithStr:B WhichLab:a];
    b.text =B;
    [self WithLabel:b];
    
    UILabel *c =[[UILabel alloc]init];
    [self floatWithLabel:c WithStr:C WhichLab:b];
    c.text =C;
    [self WithLabel:c];
    
    UILabel *d =[[UILabel alloc]init];
    [self floatWithLabel:d WithStr:D WhichLab:c];
    d.text =D;
    [self WithLabel:d];
    
    UILabel *e =[[UILabel alloc]init];
    [self floatWithLabel:e WithStr:E WhichLab:d];
    e.text =E;
    [self WithLabel:e];
    
    UILabel *f =[[UILabel alloc]init];
    [self floatWithLabel:f WithStr:F WhichLab:e];
    f.text =F;
    [self WithLabel:f];
    
    UILabel *g =[[UILabel alloc]init];
    [self floatWithLabel:g WithStr:G WhichLab:f];
    g.text =G;
    [self WithLabel:g];
    
    UILabel *h =[[UILabel alloc]init];
    [self floatWithLabel:h WithStr:H WhichLab:g];
    h.text =H;
    [self WithLabel:h];
    
    UILabel *i =[[UILabel alloc]init];
    [self floatWithLabel:i WithStr:I  WhichLab:h];
    i.text =I;
    [self WithLabel:i];
    
    UILabel *j =[[UILabel alloc]init];
    [self floatWithLabel:j WithStr:J WhichLab:i];
    j.text =J;
    [self WithLabel:j];
    
    UILabel *k =[[UILabel alloc]init];
    [self floatWithLabel:k WithStr:K WhichLab:j];
    k.text =K;
    [self WithLabel:k];
    
    UILabel *l =[[UILabel alloc]init];
    [self floatWithLabel:l WithStr:L WhichLab:k];
    l.text =L;
    [self WithLabel:l];
    
    UILabel *m = [[UILabel alloc]init];
    [self floatWithLabel:m WithStr:M WhichLab:l];
    m.text =M;
    [self WithLabel:m];
    
    UILabel *n = [[UILabel alloc]init];
    [self floatWithLabel:n WithStr:N WhichLab:m];
    n .text =N;
    [self WithLabel:n];
    
    UILabel *o = [[UILabel alloc]init];
    [self floatWithLabel:o WithStr:O WhichLab:n];
    o.text =O;
    [self WithLabel:o];
    
    UILabel *p =[[UILabel alloc]init];
    [self floatWithLabel:p WithStr:P WhichLab:o];
    p.text =P;
    [self WithLabel:p];
    
    UILabel *q =[[UILabel alloc]init];
    [self floatWithLabel:q WithStr:Q WhichLab:p];
    q.text =Q;
    [self WithLabel:q];
    
    UILabel *r =[[UILabel alloc]init];
    [self floatWithLabel:r WithStr:R WhichLab:q];
    r .text =R;
    [self WithLabel:r];
    
    UILabel *s =[[UILabel alloc]init];
    [self floatWithLabel:s WithStr:S WhichLab:r];
    s.text =S;
    [self WithLabel:s];
    
    UILabel *t =[[UILabel alloc]init];
    [self floatWithLabel:t WithStr:T WhichLab:s ];
    t.text =T;
    [self WithLabel:t];
    
    UILabel *u =[[UILabel alloc]init];
    [self floatWithLabel:u WithStr:U WhichLab:t ];
    u .text =U;
    [self WithLabel:u];
    
    UILabel *v =[[UILabel alloc]init];
    [self floatWithLabel:v WithStr:V WhichLab:u ];
    v.text =V;
    [self WithLabel:v];
    
    UILabel *w =[[UILabel alloc]init];
    [self floatWithLabel:w WithStr:W WhichLab:v ];
    w.text =W;
    [self WithLabel:w];
    
    UILabel *x =[[UILabel alloc]init];
    [self floatWithLabel:x WithStr:X WhichLab:w ];
    x.text =X;
    [self WithLabel:x];
    
    UILabel *y =[[UILabel alloc]init];
    [self floatWithLabel:y WithStr:Y WhichLab:x ];
    y .text =Y;
    [self WithLabel:y];
    

    
    
}

- (CGFloat )rectWithStr:(NSString *)str{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:TextMainCOLOR} context:nil];
    return rect.size.height;
}

- (void)WithLabel:(UILabel *)label{
    label.textColor = kTextMainCOLOR;
    label.numberOfLines = 0 ;
    label.lineBreakMode = UILineBreakModeCharacterWrap;
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    [scrollview addSubview:label];
//      CGSize size = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil]];
    CGRect tmpRect = [label.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    _lbl_height=_lbl_height+tmpRect.size.height;
    scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _lbl_height-800);

}

- (void )floatWithLabel:(UILabel *)label WithStr:(NSString *)Str WhichLab:(UILabel *)WL{
    
    label.frame = CGRectMake(10,10+WL.frame.origin.y+WL.frame.size.height, SCREEN_WIDTH-20,[self rectWithStr:Str]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
