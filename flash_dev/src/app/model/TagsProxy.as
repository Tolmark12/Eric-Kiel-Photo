package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;

public class TagsProxy extends Proxy implements IProxy
{
	public static const NAME:String = "tags_proxy";
	public static const NUM_OF_SUGGESTIONS:Number = 15;
	
	private var _search:SearchVo ;
	
	// Constructor
	public function TagsProxy( ):void { 
		super( NAME ); 
		_search = new SearchVo(_tags.length);
	};
	
	
	/** 
	*	Clear the current search, and build a new one
	*/
	public function newSearch (  ):void
	{
		_search = new SearchVo(_tags.length);
	}
	
	/** 
	*	This is called everytime the search term changes
	*	@param		The entire new term
	*/
	public function onSearchTermChange ( $newTerm:String ):void
	{
		$newTerm = $newTerm.toLowerCase();
		var newWordLength:uint = $newTerm.length;
		
		// If string is empty:
		if( newWordLength == 0 ) {
			sendNotification( AppFacade.DISPLAY_TAG_HINTS, [] );
			_search = new SearchVo(_tags.length);
		}
		
		// else:
		else{
			// If current searched word is longer than the new one
			// trim off the extra letters.
			// ex: word    search  ->   sear
			if( _search.letters.length > newWordLength )
				_search.clearFromIndex(newWordLength)
			
			// Itterate through the word and compare each letter with 
			// the letters found in the current search. If they differ
			// at any point, we trim off that letter and the remaining
			// letters from the current search. Then call : addLetterToSearch( "newLetterThat'sDifferent" )
			var len:uint = newWordLength;
			for ( var i:uint=0; i<len; i++ ) 
			{
				// If a letter at this index exists...
				if( _search.letters.length > i ) {
					//...if the letters are different...
					if( _search.letters[i].letter != $newTerm.charAt(i) ){
						//..clear existing letters and...
						_search.clearFromIndex(i);
						//...add new letter
						addLetterToSearch( $newTerm.charAt(i) );
					}
					///...if letters are the same, send the existing array:
					else{
						_sendAr();
					}
				}
				// Else if there is no existing letter at this index, we simply
				// add the new letter to the existing word.
				else{
					addLetterToSearch( $newTerm.charAt(i) );
				}
			}
		}
	}
	
	/** 
	*	Add another letter to the existing search stack
	*	@param		the Letter to find in the words
	*/
	public function addLetterToSearch ( $letter:String ):void
	{
		//// if the last letter did find matches, search for next match:
		if( _search.startIndex != -1 ){
			var count:uint 					= _search.startIndex;		// Itterator
			var letterIndex:Number 			= _search.word.length;		// The position of the letter in the word we're looking at
			var firstInstanceFound:Boolean	= false;					// Set to true after the first match is found
			var firstIndex:Number			= -1;						// Index of the first match (in the array)
			var lastIndex:Number			= _search.endIndex;			// Index of the last match
			
			// Loop through each word in the stack, and test it's letter at letter
			// Index to see if it matches the new letter. Use the first and last words
			// matched to define the starting / ending points of the set
			while(count < _search.endIndex){
				var testLetter:String 	= _tags[count].charAt(letterIndex);
				var isMatch:Boolean		= testLetter == $letter
				// If the first match has been found in previous itteration...
				if( firstInstanceFound ) {
					//...and the letters DON'T match... 
					if( !isMatch ){
						//...then this is the last index.
						lastIndex = count;
						break;
					}
				}
				// If the first match has not been found & the letters match..
				else if( !firstInstanceFound && isMatch ){
					//...this is the first index
					firstInstanceFound = true;
					firstIndex = count;
					// lastIndex  = count+1;
				}
				count++
			} // : Loop END
			
			// If no terms matched this new letter, add a non-match instance:
			if( !firstInstanceFound ){
				_search.addLetterToSearch($letter, -1, -1 );
			}
			
			// else match(es) were were found:
			else{
				_search.addLetterToSearch($letter, firstIndex, lastIndex );
				_sendAr()
			}
		}
		
		//// else, since the last letter didn't match, neither will this one
		//// add another letter matching nothing:
		else{
			_search.addLetterToSearch($letter, -1, -1 );
		}
	}
	
	
	
	// _____________________________ Helpers
	
	private function _sendAr (  ):void {
		var resultsAr:Array = _tags.slice(_search.startIndex, _search.endIndex);
		resultsAr.splice( NUM_OF_SUGGESTIONS );
		sendNotification( AppFacade.DISPLAY_TAG_HINTS, resultsAr );
	}
	
	
	
	
	//// TEMP DATA FOR TESTING
	private var _tags:Array = [
        "aardvark",
        "aardwolf",
        "abalone",
        "abyssinian cat",
        "abyssinian ground hornbill",
        "acacia rat",
        "achilles tang",
        "acorn barnacle",
        "acorn weevil",
        "acorn woodpecker",
        "acouchi (rodent resembling a squirrel)",
        "adams stag-horned beetle",
        "addax",
        "adder",
        "adelie penguin",
        "admiral",
        "admiral butterfly",
        "adouri",
        "african augur buzzard",
        "african bush viper",
        "african civet",
        "african clawed frog",
        "african elephant",
        "african fish eagle",
        "african golden cat",
        "african ground hornbill",
        "african harrier hawk",
        "african hornbill",
        "african jacana",
        "african mole snake",
        "african paradise flycatcher",
        "african pied kingfisher",
        "african porcupine",
        "african rock python",
        "african wild cat",
        "african wild dog",
        "agama",
        "agouta (rodent resembling a mouse)",
        "agouti (rodent resembling a squirrel)",
        "airedale",
        "aisan pied starling",
        "akita inu",
        "alabama map turtle",
        "alaska jingle",
        "alaskan husky",
        "alaskan malamute",
        "albacore tuna",
        "albatross",
        "albertosaurus",
        "albino",
        "aldabra tortoise",
        "allens big-eared bat",
        "alligator",
        "alligator gar",
        "alligator snapping turtle",
        "allosaurus",
        "alpaca",
        "alpine black swallowtail butterfly",
        "alpine goat",
        "alpine road guide tiger beetle",
        "altiplano chinchilla mouse",
        "amazon dolphin",
        "amazon parrot",
        "amazon tree boa",
        "amber pen shell",
        "american alligator",
        "american avocet",
        "american badger",
        "american bittern",
        "american black vulture",
        "american cicada",
        "american crayfish",
        "american crocodile",
        "american crow",
        "american goldfinch",
        "american kestrel",
        "american lobster",
        "american marten",
        "american ratsnake",
        "american red squirrel",
        "american river otter",
        "american robin",
        "american toad",
        "american wigeon",
        "amethyst gem clam",
        "amethyst sunbird",
        "amethystine python",
        "ammonite",
        "amoeba",
        "amphibian",
        "amphiuma",
        "amur minnow",
        "amur ratsnake",
        "amur starfish",
        "anaconda",
        "anchovy",
        "andean cat",
        "andean cock-of-the-rock",
        "andean condor",
        "anemone",
        "anemone crab",
        "anemone shrimp",
        "angel wing mussel",
        "angelfish",
        "anglerfish",
        "angora",
        "angwantibo",
        "anhinga",
        "animated",
        "ankole",
        "ankole-watusi",
        "annas hummingbird",
        "annelida",
        "annelid",
        "anole",
        "anopheles",
        "antarctic fur seal",
        "antarctic giant petrel",
        "anteater",
        "antelope",
        "antelope ground squirrel",
        "antipodes green parakeet",
        "ant",
        "ant bear",
        "ant lion",
        "anura",
        "aoudad",
        "apatosaur",
        "ape",
        "aphid",
        "apis dorsata laboriosa",
        "aplomado falcon",
        "aquatic leech",
        "arabian horse",
        "arabian oryx",
        "arabian wild cat",
        "aracari",
        "arachnid",
        "arawana",
        "archaeocete",
        "archaeopteryx",
        "archer fish",
        "arctic fox",
        "arctic hare",
        "arctic wolf",
        "argali",
        "argentine horned frog",
        "argentine ruddy duck",
        "argus fish",
        "ariel toucan",
        "arizona alligator lizard",
        "ark shell",
        "armadillo",
        "armed crab",
        "armed nylon shrimp",
        "army ant",
        "arrow crab",
        "arrow worm",
        "arrowana",
        "arthropods",
        "aruanas",
        "asian constable butterfly",
        "asian damselfly",
        "asian elephant",
        "asian lion",
        "asian porcupine",
        "asian small-clawed otter",
        "asian trumpetfish",
        "asian water buffalo",
        "asiatic greater freshwater clam",
        "asiatic lesser freshwater clam",
        "asiatic mouflon",
        "asiatic wild ass",
        "asp",
        "ass",
        "assassin bug",
        "astarte",
        "astrangia coral",
        "atlantic black goby",
        "atlantic blue tang",
        "atlantic ridley turtle",
        "atlantic sharpnose puffer",
        "atlantic spadefish",
        "atlas moth",
        "attwater's prairie chicken",
        "auk",
        "auklet",
        "aurochs",
        "australian curlew",
        "australian freshwater crocodile",
        "australian fur seal",
        "australian kestrel",
        "australian shelduck",
        "australian silky terrier",
        "avocet",
        "axis deer",
        "axolotl",
        "aye-aye",
        "aztec ant",
        "azure-winged magpie",
        "azure vasebabirusa",
        "baboon",
        "bactrian",
        "badger",
        "bagworm",
        "baiji",
        "bald eagle",
        "baleen whale",
        "balloonfish",
        "bandicoot",
        "banteng",
        "barasinga",
        "barasingha",
        "barb",
        "barbet",
        "barnacle",
        "barracuda",
        "basilisk",
        "bass",
        "basset hound",
        "bat",
        "bear",
        "bearded dragon",
        "beaver",
        "bee",
        "beetle",
        "bell frog",
        "beluga whale",
        "bettong",
        "big-horned sheep",
        "bighorn",
        "bilby",
        "binturong",
        "bird",
        "bird of paradise",
        "bison",
        "bittern",
        "black bear",
        "black fly",
        "black panther",
        "black rhino",
        "black widow spider",
        "blackbird",
        "blackbuck",
        "blesbok",
        "blowfish",
        "blue jay",
        "blue whale",
        "bluebird",
        "bluebottle",
        "bluefish",
        "boa",
        "boa constrictor",
        "boar",
        "bobcat",
        "bobolink",
        "bobwhite",
        "bongo",
        "booby",
        "boto",
        "boubou",
        "boutu",
        "bovine",
        "brahman bull",
        "brahman cow",
        "brant",
        "bream",
        "brocket deer",
        "bronco",
        "brontosaurus",
        "brown bear",
        "bubblefish",
        "buck",
        "budgie",
        "bufeo",
        "buffalo",
        "bufflehead",
        "bug",
        "bull mastiff",
        "bullfrog",
        "bumblebee",
        "bunny",
        "bunting",
        "burro",
        "bush baby",
        "bush squeaker",
        "bustard",
        "butterfly",
        "buzzard",
        "caecilian",
        "caiman",
        "caiman lizard",
        "calf",
        "camel",
        "canary",
        "canine",
        "canvasback",
        "cape ghost frog",
        "capybara",
        "caracal",
        "cardinal",
        "caribou",
        "carp",
        "cassowary",
        "cat",
        "catbird",
        "caterpillar",
        "catfish",
        "cattle",
        "caudata",
        "cavy",
        "centipede",
        "chafer",
        "chameleon",
        "chamois",
        "cheetah",
        "chevrotain",
        "chick",
        "chickadee",
        "chicken",
        "chihuahua",
        "chimney swift",
        "chimpanzee",
        "chinchilla",
        "chinese crocodile lizard",
        "chipmunk",
        "chital",
        "chrysomelid",
        "chuckwalla",
        "chupacabra",
        "cicada",
        "cirriped",
        "civet",
        "clam",
        "cleaner wrasse",
        "clown anemone fish",
        "clumber",
        "coati",
        "cob",
        "cobra",
        "cockatiel",
        "cockatoo",
        "cocker spaniel",
        "cockroach",
        "cod",
        "coelacanth",
        "collard lizard",
        "colt",
        "comet",
        "conch",
        "condor",
        "coney",
        "conure",
        "coot",
        "cooter",
        "copepod",
        "copperhead",
        "coqui",
        "coral",
        "cormorant",
        "corn snake",
        "corydoras catfish",
        "cottonmouth",
        "cottontail",
        "cougar",
        "cow",
        "cowbird",
        "cowrie",
        "coyote",
        "coypu",
        "crab",
        "crane",
        "crayfish",
        "cricket",
        "crocodile",
        "crocodile skink",
        "crossbill",
        "crow",
        "crown-of-thorns starfish",
        "crustacean",
        "cub",
        "cuckoo",
        "curassow",
        "curlew",
        "cuscus",
        "cusimanse",
        "cuttlefish",
        "dachshund",
        "daddy longlegs",
        "dairy cow",
        "dalmatian",
        "damselfly",
        "dandie dinmont terrier",
        "dart frog",
        "dassie",
        "dassies",
        "dassie rat",
        "deer",
        "deer mouse",
        "degu",
        "degus",
        "desert pupfish",
        "deinonychus",
        "devil fish",
        "devil tasmanian",
        "diaea dorsata",
        "diamondback rattlesnake",
        "dik-dik, dikkops bird",
        "dingo",
        "dinosaur",
        "diplodocus",
        "dipper",
        "discus",
        "doberman pinscher",
        "doctorfish",
        "dodo bird",
        "doe",
        "dog",
        "dogue de bordeaux",
        "dogwood clubgall",
        "dogwood twig borer",
        "dolphin",
        "donkey",
        "dorado",
        "dore",
        "dorking",
        "dormouse",
        "dotterel",
        "douglas fir bark beetle",
        "dove",
        "dowitcher",
        "draft horse",
        "dragon",
        "dragonfly",
        "drake",
        "dromedary",
        "drongo",
        "duck",
        "duckbill platypus",
        "duckling",
        "dugong",
        "duiker",
        "dung beetle",
        "dungeness crab",
        "dunlin",
        "dunnart",
        "dwarf mongoose",
        "eagle",
        "earthworm",
        "echidna",
        "eel",
        "eeve",
        "eft",
        "egret",
        "eider",
        "eidolon helvum",
        "ekaltadeta",
        "eland",
        "electric eel",
        "elephant",
        "elk",
        "elver",
        "emu",
        "ermine",
        "erne",
        "esok",
        "ewe",
        "eyas",
        "eyra",
        "fairy bluebird",
        "fairy flies",
        "fairy fly",
        "falcon",
        "fallow deer",
        "fan worms",
        "fantail",
        "fat-tailed dunnart",
        "fawn",
        "felid",
        "felidae",
        "feline",
        "fennec fox",
        "ferret",
        "fiddler crab",
        "field mouse",
        "fin whale",
        "finch",
        "fire bellied toad",
        "firefly",
        "fish",
        "flamingo",
        "flatfish",
        "flea",
        "flicker",
        "flickertail squirrel",
        "flies",
        "flounder",
        "fluke",
        "fly",
        "flycatcher",
        "flying fox",
        "flying lemur",
        "flying squirrel",
        "foal",
        "fossa",
        "fowl",
        "fox",
        "frigate bird",
        "frilled lizard",
        "frog",
        "frogmouth",
        "fruit bat",
        "fugu",
        "fulmar",
        "funnel weaver spider",
        "fur seal",
        "gadwall",
        "galago",
        "galah",
        "galapagos albatross",
        "galapagos dove",
        "galapagos hawk",
        "galapagos mockingbird",
        "galapagos penguin",
        "galapagos sea lion",
        "galapagos tortoise",
        "gallinule",
        "gander",
        "gannet",
        "gar",
        "gaur",
        "gavial",
        "gazelle",
        "gecko",
        "geese",
        "gelada",
        "gemsbok",
        "gemsbuck",
        "gerbil",
        "gerenuk",
        "german shepherd",
        "gharial",
        "gibbon",
        "gila monster",
        "giraffe",
        "glassfrog",
        "globefish",
        "gnatcatcher",
        "gnat",
        "gnu",
        "goa",
        "goat",
        "godwit",
        "goitered",
        "goldeneye",
        "goldfinch",
        "goldfish",
        "goose",
        "goosefish",
        "gopher",
        "gorilla",
        "goshawk",
        "gosling",
        "grackle",
        "grass spider",
        "grasshopper",
        "grayling",
        "gray fox",
        "gray wolf",
        "great argus",
        "grebe",
        "greyhound dog",
        "grison",
        "grizzly bear",
        "grosbeak",
        "groundhog",
        "grouse",
        "grunion",
        "guanaco",
        "guib",
        "guillemot",
        "guinea fowl",
        "guinea pig",
        "gull",
        "guppy",
        "gyrfalcon",
        "hackee",
        "haddock",
        "hadrosaurus",
        "hag-fish",
        "hairstreak",
        "hake",
        "halcyon",
        "halibut",
        "halicore",
        "hamadryad",
        "hamadryas",
        "hammerhead bird",
        "hammerhead shark",
        "hammerkop",
        "hamster",
        "hanuman-monkey",
        "hapuka",
        "hapuku",
        "harbor-porpoise",
        "harbor-seal",
        "hare",
        "harp-seal",
        "harpy-eagle",
        "harrier",
        "harrier hawk",
        "hart",
        "hartebeest",
        "harvest mouse",
        "harvestmen",
        "hatchet-fish",
        "hawaiian-monk seal",
        "hawk",
        "hector's dolphin",
        "hedgehog",
        "heifer",
        "hellbender",
        "hen",
        "herald",
        "hercules-beetle",
        "hermit crab",
        "heron",
        "herring",
        "heterodontosaurus",
        "hind",
        "hippo",
        "hippopotamus",
        "hoatzin",
        "hochstetter's frog",
        "hog",
        "hogget",
        "hoiho",
        "hoki",
        "homalocephale",
        "honey-badger",
        "honeybee",
        "honey-creeper",
        "honeyeater",
        "hoopoe",
        "horn-shark",
        "horned-toad",
        "horned-viper",
        "hornbill",
        "hornet",
        "horse",
        "horsefly",
        "horseshoe bat",
        "horseshoe crab",
        "hound",
        "house-mouse",
        "housefly",
        "howler-monkey",
        "huemul (deer)",
        "huia",
        "hummingbird",
        "humpback whale",
        "husky",
        "hydatid-tapeworm",
        "hydra",
        "hyena",
        "hylaeosaurus",
        "hypacrosaurus",
        "hypsilophodon",
        "hyracotherium",
        "hyrax",
        "ibex",
        "ibis",
        "ichthyosaurs",
        "iguana",
        "iguanodon",
        "impala",
        "imperator angel",
        "imperial eagle",
        "indian elephant",
        "insects",
        "intermediate egret",
        "iriomote cat",
        "irukandji jellyfish",
        "isopod",
        "ivory-billed woodpecker",
        "jabiru",
        "jackal",
        "jackrabbit",
        "jaeger",
        "jaguar",
        "jaguarundi",
        "janenschia",
        "jay",
        "jellyfish",
        "jenny",
        "jerboa",
        "joey",
        "john dory",
        "junco",
        "june bug",
        "kagu",
        "kakapo",
        "kakarikis",
        "kangaroo",
        "karakul",
        "katydid",
        "kawala",
        "kentrosaurus",
        "kestrel",
        "kid",
        "killdeer",
        "killer whale",
        "killifish",
        "kingbird",
        "kingfisher",
        "kinglet",
        "kingsnake",
        "kinkajou",
        "kiskadee",
        "kit fox",
        "kite",
        "kitten",
        "kittiwake",
        "kitty",
        "kiwi (bird)",
        "koala",
        "koala bear",
        "kob (african antelope)",
        "kodiak bear",
        "koi",
        "komodo dragon",
        "koodoo",
        "kookaburra",
        "kouprey",
        "krill",
        "kronosaurus",
        "kudu",
        "kusimanse",
        "labrador",
        "ladybird",
        "ladybug",
        "lamb",
        "lamprey",
        "langur",
        "lark",
        "laughingthrush",
        "leafbird",
        "leafhopper",
        "leafwing",
        "leech",
        "lemming",
        "lemur",
        "leonberger",
        "leopard",
        "leopard seal",
        "leveret",
        "lhasa apso",
        "lice",
        "liger",
        "lightningbug",
        "limpet",
        "limpkin",
        "ling",
        "lion",
        "lionfish",
        "lizard",
        "llama",
        "lobo",
        "lobster",
        "locust",
        "logger head turtle",
        "longhorn",
        "longspur",
        "loon",
        "lorikeet",
        "loris",
        "louse",
        "lovebird",
        "lowchen",
        "lungfish",
        "lynx",
        "macaque",
        "macaw",
        "macropod",
        "madagascar hissing roach",
        "magpie",
        "maiasaura",
        "majungatholus",
        "malamute",
        "mallard",
        "maltese dog",
        "mamba",
        "mamenchisaurus",
        "mammal",
        "mammoth",
        "manatee",
        "mandrill",
        "mangabey",
        "manta",
        "manta ray",
        "mantis",
        "mantis ray",
        "manx cat",
        "mara",
        "marabou",
        "marbled murrelet",
        "mare",
        "marlin",
        "marmoset",
        "marmot",
        "marten",
        "martin",
        "massasauga",
        "massospondylus",
        "mastiff",
        "mastodon",
        "meadowlark",
        "meerkat",
        "megalosaurus",
        "megalotomus quinquespinosus",
        "megaraptor",
        "merganser",
        "merlin",
        "mice",
        "microvenator",
        "midge",
        "milksnake",
        "millipede",
        "minibeast",
        "mink",
        "minnow",
        "mite",
        "moa",
        "mockingbird",
        "mole",
        "mollies",
        "mollusk",
        "molly",
        "monarch",
        "mongoose",
        "monkey",
        "monkfish",
        "monoclonius",
        "montanoceratops",
        "moorhen",
        "moray",
        "moray eel",
        "moose",
        "mosasaur",
        "mosquito",
        "moth",
        "motmot",
        "mouflon",
        "mountain cat",
        "mountain lion",
        "mouse",
        "mousebird",
        "mouse/mice",
        "mud puppy",
        "mule",
        "mullet",
        "muntjac",
        "murrelet",
        "musk ox",
        "muskrat",
        "mussaurus",
        "mussel",
        "mustang",
        "myna",
        "mynah",
        "myotis",
        "nabarlek",
        "nag",
        "naga",
        "nagapies",
        "naked mole rat",
        "nandine",
        "nandoo",
        "nandu",
        "narwhal",
        "narwhale",
        "natterjack toad",
        "nauplius",
        "nautilus",
        "needle fish",
        "needletail",
        "nematode",
        "nene",
        "neon blue guppy",
        "neon blue hermit crab",
        "neon dwarf gourami",
        "neon rainbow fish",
        "neon red guppy",
        "neon tetra",
        "nerka",
        "nettlefish",
        "newfoundland dog",
        "newt",
        "newt nutria",
        "night crawler",
        "night heron",
        "nighthawk",
        "nightingale",
        "nightjar",
        "nijssenis's dwarf chihlid",
        "nilgai",
        "nine banded armadillo",
        "noctilio",
        "noctule",
        "noddy",
        "noolbenger",
        "northern cardinals",
        "northern elephant seal",
        "northern flying squirrel",
        "northern fur seal",
        "northern hairy-nosed wombat",
        "northern pike",
        "northern sea horse",
        "northern spotted owl",
        "norway lobster",
        "norway rat",
        "nubian goat",
        "nudibranch",
        "numbat",
        "nurse shark",
        "nutcracker",
        "nuthatch",
        "nutria",
        "nyala",
        "nymph",
        "ocelot",
        "octopus",
        "okapi",
        "olingo",
        "olm",
        "opossum",
        "orangutan",
        "orca",
        "oriole",
        "oropendola",
        "oropendula",
        "oryx",
        "osprey",
        "ostracod",
        "ostrich",
        "otter",
        "ovenbird",
        "owl",
        "ox",
        "oxen",
        "oxpecker",
        "oyster",
        "ozark big-eared bat",
        "paca",
        "pacific parrotlet",
        "paddlefish",
        "panda",
        "pangolin",
        "panther",
        "papillon",
        "parakeet",
        "parrot",
        "partridge",
        "peacock",
        "peafowl",
        "peccary",
        "pekingese",
        "pelican",
        "pelicinus petrel",
        "penguin",
        "perch",
        "peregrine falcon",
        "pewee",
        "phalarope",
        "pharaoh hound",
        "pheasant",
        "phoebe",
        "phoenix",
        "pig",
        "pigeon",
        "piglet",
        "pika",
        "pike",
        "pikeperch",
        "pilchard",
        "pine marten",
        "pink river dolphin",
        "pinniped",
        "pintail",
        "pipistrelle",
        "pipit",
        "piranha",
        "pit bull",
        "pitta bird",
        "plain squeaker",
        "plankton",
        "platypus",
        "plover",
        "polar bear",
        "polecat",
        "polliwog",
        "polyp",
        "polyturator",
        "pomeranian",
        "pony",
        "poodle",
        "porcupine",
        "porpoise",
        "portuguese man of war",
        "possum",
        "prairie dog",
        "prawn",
        "praying mantis",
        "primate",
        "pronghorn",
        "pseudodynerus quadrisectus",
        "ptarmigan",
        "pterodactyls",
        "pterosaurs",
        "puffer",
        "puffer fish",
        "puffin",
        "pug",
        "pullet",
        "puma",
        "pup fish",
        "puppy",
        "purple marten",
        "pygmy",
        "python",
        "quadrisectus",
        "quagga",
        "quahog",
        "quail",
        "queen alexandra's birdwing",
        "queen ant",
        "queen bee",
        "queen conch",
        "queen snake",
        "queensland grouper",
        "queensland heeler",
        "quelea",
        "quetzal",
        "quetzalcoatlus",
        "quillback",
        "quinquespinosus",
        "quokka",
        "quoll",
        "rabbit",
        "rabid squirrel",
        "raccoon",
        "racer",
        "racerunner",
        "ragfish",
        "rail",
        "rainbow fish",
        "rainbow lorikeet",
        "rainbow trout",
        "ram",
        "raptors",
        "rasbora",
        "rat",
        "rat fish",
        "rattail",
        "rattlesnake",
        "raven",
        "ray",
        "red-tailed hawk",
        "redhead",
        "redheaded woodpecker",
        "redpoll",
        "redstart",
        "reindeer",
        "reptile",
        "reynard",
        "rhea",
        "rhesus monkey",
        "rhino",
        "rhinoceros",
        "rhinoceros beetle",
        "rhodesian ridgeback",
        "ring tailed lemur",
        "ringworm",
        "rio grande escuerzo",
        "roach",
        "roadrunner",
        "roan",
        "robin",
        "rock rat",
        "rodent",
        "roebuck",
        "roller",
        "rook",
        "rooster",
        "rottweiler",
        "sable",
        "sable antelope",
        "sablefish",
        "saiga",
        "saki monkey",
        "salamander",
        "salmon",
        "salt water crocodile",
        "sambar",
        "samoyed dog",
        "sand dollar",
        "sandbar shark",
        "sanderling",
        "sandpiper",
        "sapsucker",
        "sardine",
        "sawfish",
        "scallop",
        "scarab",
        "scarlet ibis",
        "scaup",
        "schapendoes",
        "schipperke",
        "schnauzer",
        "scorpion",
        "scoter",
        "screamer",
        "sea hog",
        "seahorse",
        "sea lion",
        "sea monkey",
        "sea slug",
        "sea urchin",
        "seabird",
        "seagull",
        "seal",
        "senegal python",
        "seriema",
        "serpent",
        "serval",
        "shark",
        "shearwater",
        "sheep",
        "sheldrake",
        "shelduck",
        "shiba inu",
        "shih tzu",
        "shorebird",
        "shoveler",
        "shrew",
        "shrike",
        "shrimp",
        "siamang",
        "siamese cat",
        "siberian tiger",
        "sidewinder",
        "sifaka",
        "silkworm",
        "silver fox",
        "silverfish",
        "silverside fish",
        "siskin",
        "skimmer",
        "skink",
        "skipper",
        "skua",
        "skunk",
        "skylark",
        "sloth",
        "sloth bear",
        "slug",
        "smelts",
        "smew",
        "snail",
        "snake",
        "snipe",
        "snow dog",
        "snow geese",
        "snow leopard",
        "snow monkey",
        "snowy owl",
        "sockeye salmon",
        "solenodon",
        "solitaire",
        "songbird",
        "sora",
        "southern hair nosed wombat",
        "sow",
        "spadefoot",
        "sparrow",
        "sphinx",
        "spider",
        "spider monkey",
        "spiketail",
        "sponge",
        "spoonbill",
        "spotted dolphin",
        "spreadwing",
        "spring peeper",
        "springbok",
        "squab",
        "squamata",
        "squeaker",
        "squid",
        "squirrel",
        "stag",
        "stag beetle",
        "stallion",
        "starfish",
        "starling",
        "steed",
        "steer",
        "stegosaurus",
        "stick insect",
        "stickleback",
        "stilt",
        "stingray",
        "stinkbug",
        "stinkpot",
        "stoat",
        "stork",
        "stud",
        "sturgeon",
        "sugar glider",
        "sun bear",
        "sun bittern",
        "sunfish",
        "swallow",
        "swallowtail",
        "swan",
        "swellfish",
        "swift",
        "swordfish",
        "t-rex",
        "tadpole",
        "tahr",
        "takin",
        "tamarin",
        "tanager",
        "tapaculo",
        "tapeworm",
        "tapir",
        "tarantula",
        "tarpan",
        "tarsier",
        "taruca",
        "tasmanian devil",
        "tasmanian tiger",
        "tattler",
        "tayra",
        "teal",
        "tegus",
        "teledu (se asian mammal)",
        "tench",
        "tenrec",
        "termite",
        "tern",
        "terrapin",
        "terrier",
        "thrasher",
        "thrush",
        "thunderbird",
        "thylacine",
        "tick",
        "tiger",
        "tiger shark",
        "tilefish",
        "tinamou",
        "titi",
        "titmouse",
        "toad",
        "toadfish",
        "tomtit",
        "topi",
        "tortoise",
        "toucan",
        "towhee",
        "tragopan",
        "treecreeper",
        "triceratops",
        "trogon",
        "trout",
        "trumpeter bird",
        "trumpeter swan",
        "tsetse fly",
        "tuatara",
        "tuna",
        "turaco",
        "turkey",
        "turnstone",
        "turtle",
        "turtle dove",
        "tyrannosaurus rex",
        "uakari",
        "uganda kob",
        "uinta ground squirrel",
        "umbrella bird",
        "umbrette",
        "unau",
        "ungulate",
        "unicorn",
        "upupa",
        "urchin",
        "urial",
        "uromastyx maliensis",
        "uromastyx spinipes",
        "urson",
        "urubu",
        "urus",
        "urutu",
        "urva",
        "utah prairie dog",
        "vampire bat",
        "vaquita",
        "veery",
        "velociraptor",
        "velvet crab",
        "velvet worm",
        "venomous snake",
        "verdin",
        "vervet",
        "vicuna",
        "viper",
        "viper squid",
        "viperfish",
        "vireo",
        "virginia opossum",
        "vixen",
        "vole",
        "volvox",
        "vulpes velox",
        "vulpes vulpes",
        "vulture",
        "wallaby",
        "wallaroo",
        "walleye",
        "walrus",
        "warbler",
        "warthog",
        "wasp",
        "water buffalo",
        "water dragons",
        "water moccasin",
        "waterbuck",
        "waterdogs",
        "waterthrush",
        "wattlebird",
        "watussi",
        "waxwing",
        "weasel",
        "weaver bird",
        "weevil",
        "whale",
        "whapuku",
        "whelp",
        "whimbrel",
        "whippet",
        "whippoorwill",
        "white beaked dolphin",
        "white-eye",
        "white pelican",
        "white rhino",
        "white tailed deer",
        "white tipped reef shark",
        "whooper",
        "whooping crane",
        "widgeon",
        "widow spider",
        "wildcat",
        "wildebeest",
        "willet",
        "wireworm",
        "wisent",
        "wobbegong shark",
        "wolf",
        "wolf spider",
        "wolverine",
        "wombat",
        "wood storks",
        "woodchuck",
        "woodcock",
        "woodpecker",
        "worm",
        "wrasse",
        "wreckfish",
        "wren",
        "wrench bird",
        "wryneck",
        "wuerhosaurus",
        "wyvern",
        "x-ray fish",
        "x-ray tetra",
        "xanclomys",
        "xanthareel",
        "xantus",
        "xantus murrelet",
        "xeme",
        "xenarthra",
        "xenoposeidon",
        "xenops",
        "xenopterygii",
        "xenopus",
        "xenotarsosaurus",
        "xenurine",
        "xenurus unicinctus",
        "xerus",
        "xiaosaurus",
        "xinjiangovenator",
        "xiphias",
        "xiphias gladius",
        "xiphosuran",
        "xoloitzcuintli",
        "xoni",
        "xuanhanosaurus",
        "xuanhuaceratops",
        "xuanhuasaurus",
        "yaffle",
        "yak",
        "yapok",
        "yard ant",
        "yearling",
        "yellow bellied marmot",
        "yellow belly lizard",
        "yellow lab",
        "yellowhammer",
        "yellowjacket",
        "yellowlegs",
        "yellowthroat",
        "yeti",
        "ynambu",
        "yorkie",
        "yorkshire terrier",
        "yosemite toad",
        "yucker",
        "zander",
        "zanzibar day gecko",
        "zebra",
        "zebra dove",
        "zebra finch",
        "zebra-tailed lizard",
        "zebrafish",
        "zebu",
        "zenaida",
        "zeren",
        "zethus spinipes",
        "zethus wasp",
        "zigzag salamander",
        "zone-tailed pigeon",
        "zooplankton",
        "zoozoo",
        "zopilote",
        "zorilla"
    ];

}
}