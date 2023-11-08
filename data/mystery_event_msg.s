@ These are event scripts. They should not be moved to C.

#include "constants/global.h"
#include "constants/flags.h"
#include "constants/moves.h"
#include "constants/songs.h"
#include "constants/species.h"
#include "constants/vars.h"
#include "constants/items.h"
#include "constants/region_map_sections.h"
	.include "asm/macros.inc"
	.include "asm/macros/event.inc"
	.include "constants/constants.inc"

	.section .rodata
	
	.align 2
MysteryEventScript_StampCard::
	setvaddress MysteryEventScript_StampCard
	setorcopyvar VAR_RESULT, 1
	specialvar VAR_0x8008, GetMysteryGiftCardStat
	setorcopyvar VAR_RESULT, 0
	specialvar VAR_0x8009, GetMysteryGiftCardStat
	subvar VAR_0x8008, VAR_0x8009
	buffernumberstring STR_VAR_1, VAR_0x8008
	lock
	faceplayer
	vmessage sText_MysteryGiftStampCard
	waitmessage
	waitbuttonpress
	release
	end

sText_MysteryGiftStampCard: @ 8488E55
	.string "Thank you for using the Stamp Card\n"
	.string "System.\p"
	.string "You have {STR_VAR_1} more to collect to\n"
	.string "fill your Stamp Card.$"

MysteryEventScript_SurfPichu::
	setvaddress MysteryEventScript_SurfPichu
	vgoto_if_unset FLAG_MYSTERY_GIFT_DONE, SurfPichu_GiveIfPossible
	returnram

SurfPichu_GiveIfPossible:
	specialvar VAR_EVENT_PICHU_SLOT, CalculatePlayerPartyCount
	vgoto_if_eq VAR_EVENT_PICHU_SLOT, PARTY_SIZE, SurfPichu_FullParty
	setflag FLAG_MYSTERY_GIFT_DONE
	vcall SurfPichu_GiveEgg
	lock
	faceplayer
	vmessage sText_MysteryGiftEgg
	waitmessage
	waitbuttonpress
	playfanfare MUS_OBTAIN_ITEM
	waitfanfare
	release
	end

SurfPichu_FullParty:
	lock
	faceplayer
	vmessage sText_FullParty
	waitmessage
	waitbuttonpress
	release
	end

SurfPichu_GiveEgg:
	giveegg SPECIES_PICHU
	setmonmodernfatefulencounter VAR_EVENT_PICHU_SLOT
	setmonmetlocation VAR_EVENT_PICHU_SLOT, METLOC_FATEFUL_ENCOUNTER
	vgoto_if_eq VAR_EVENT_PICHU_SLOT, 1, SurfPichu_Slot1
	vgoto_if_eq VAR_EVENT_PICHU_SLOT, 2, SurfPichu_Slot2
	vgoto_if_eq VAR_EVENT_PICHU_SLOT, 3, SurfPichu_Slot3
	vgoto_if_eq VAR_EVENT_PICHU_SLOT, 4, SurfPichu_Slot4
	vgoto_if_eq VAR_EVENT_PICHU_SLOT, 5, SurfPichu_Slot5
	return

SurfPichu_Slot1:
	setmonmove 1, 2, MOVE_SURF
	return

SurfPichu_Slot2:
	setmonmove 2, 2, MOVE_SURF
	return

SurfPichu_Slot3:
	setmonmove 3, 2, MOVE_SURF
	return

SurfPichu_Slot4:
	setmonmove 4, 2, MOVE_SURF
	return

SurfPichu_Slot5:
	setmonmove 5, 2, MOVE_SURF
	return

sText_MysteryGiftEgg: @ 8488F56
	.string "Thank you for using the Mystery\n"
	.string "Gift System.\p"
	.string "From the Pokémon Center we\n"
	.string "have a gift - a Pokémon Egg!\p"
	.string "Please raise it with love and\n"
	.string "kindness.$"

sText_FullParty:
	.string "Oh, your party appears to be full.\p"
	.string "Please come see me after storing\n"
	.string "a Pokémon on a PC.$"

MysteryEventScript_VisitingTrainer::
	setvaddress MysteryEventScript_VisitingTrainer
	special ValidateEReaderTrainer
	vgoto_if_eq VAR_RESULT, 0, MysteryEventScript_VisitingTrainerArrived
	lock
	faceplayer
	vmessage sText_MysteryGiftVisitingTrainer
	waitmessage
	waitbuttonpress
	release
	end

MysteryEventScript_VisitingTrainerArrived:
	lock
	faceplayer
	vmessage sText_MysteryGiftVisitingTrainer_2
	waitmessage
	waitbuttonpress
	release
	end

sText_MysteryGiftVisitingTrainer: @ 8489063
	.string "Thank you for using the Mystery\n"
	.string "Gift System.\p"
	.string "By holding this Wonder Card, you\n"
	.string "may take part in a survey at a\l"
	.string "Pokémon Mart.\p"
	.string "Use these surveys to invite\n"
	.string "Trainers to the Sevii Islands.\p"
	.string "…Let me give you a secret\n"
	.string "password for a survey:\p"
	.string "“Give Me\n"
	.string "Awesome Trainer”\p"
	.string "Write that in on a survey and send\n"
	.string "it to the Wireless\l"
	.string "Communication System.$"

sText_MysteryGiftVisitingTrainer_2: @ 84891B0
	.string "Thank you for using the Mystery\n"
	.string "Gift System.\p"
	.string "A Trainer has arrived in the Sevii\n"
	.string "Islands looking for you.\p"
	.string "We hope you will enjoy\n"
	.string "battling the visiting Trainer.\p"
	.string "You may invite other Trainers by\n"
	.string "entering other passwords.\p"
	.string "Try looking for other passwords\n"
	.string "that may work.$"

MysteryEventScript_BattleCard::
	setvaddress MysteryEventScript_BattleCard
	vgoto_if_set FLAG_MYSTERY_GIFT_DONE, MysteryEventScript_BattleCardInfo
	setorcopyvar VAR_RESULT, 2
	specialvar VAR_0x8008, GetMysteryGiftCardStat
	vgoto_if_ne VAR_0x8008, 3, MysteryEventScript_BattleCardInfo
	lock
	faceplayer
	vmessage sText_MysteryGiftBattleCountCard_2
	waitmessage
	waitbuttonpress
	giveitem ITEM_POTION
	release
	setflag FLAG_MYSTERY_GIFT_DONE
	end

MysteryEventScript_BattleCardInfo:
	lock
	faceplayer
	vmessage sText_MysteryGiftBattleCountCard
	waitmessage
	waitbuttonpress
	release
	end

sText_MysteryGiftBattleCountCard: @ 8489301
	.string "Thank you for using the Mystery\n"
	.string "Gift System.\p"
	.string "Your Battle Count Card keeps\n"
	.string "track of your battle record against\l"
	.string "Trainers with the same Card.\p"
	.string "Look for and battle Trainers who\n"
	.string "have the same Card as you.\p"
	.string "You may check the overall rankings\n"
	.string "by reading the News.\p"
	.string "Please do give it a try!$"

sText_MysteryGiftBattleCountCard_2: @ 8489419
	.string "Thank you for using the Mystery\n"
	.string "Gift System.\p"
	.string "Congratulations!\p"
	.string "You have won a prize for winning\n"
	.string "three battles!\p"
	.string "We hope you will be inspired to\n"
	.string "battle some more.$"

MysteryEventScript_AuroraTicket::
	setvaddress MysteryEventScript_AuroraTicket
	lock
	faceplayer
	vgoto_if_set FLAG_RECEIVED_AURORA_TICKET, AuroraTicket_Obtained
	vgoto_if_set FLAG_FOUGHT_DEOXYS, AuroraTicket_Obtained
	checkitem ITEM_AURORA_TICKET, 1
	vgoto_if_eq VAR_RESULT, TRUE, AuroraTicket_Obtained
	vmessage sText_AuroraTicket1
	waitmessage
	waitbuttonpress
	checkitemspace ITEM_AURORA_TICKET, 1
	vgoto_if_eq VAR_RESULT, FALSE, AuroraTicket_NoBagSpace
	giveitem ITEM_AURORA_TICKET
	setflag FLAG_ENABLE_SHIP_BIRTH_ISLAND
	setflag FLAG_RECEIVED_AURORA_TICKET
	vmessage sText_AuroraTicket2
	waitmessage
	waitbuttonpress
	release
	end

AuroraTicket_NoBagSpace:
	vmessage sText_AuroraTicketNoPlace
	waitmessage
	waitbuttonpress
	release
	end

AuroraTicket_Obtained:
	vmessage sText_AuroraTicketGot
	waitmessage
	waitbuttonpress
	release
	end

sText_AuroraTicket1: @ 8489526
	.string "Thank you for using the Mystery\n"
	.string "Gift System.\p"
	.string "You must be {PLAYER}.\n"
	.string "There is a ticket here for you.$"

sText_AuroraTicket2:
	.string "It appears to be for use at the\n"
	.string "Vermilion City port.\p"
	.string "Why not give it a try and see what\n"
	.string "it is about?$"

sText_AuroraTicketGot: @ 84895E8
	.string "Thank you for using the Mystery\n"
	.string "Gift System.$"

sText_AuroraTicketNoPlace: @ 8489615
	.string "Oh, I'm sorry, {PLAYER}. Your Bag's\n"
	.string "Key Items Pocket is full.\p"
	.string "Please store something on your PC,\n"
	.string "then come back for this.$"

MysteryEventScript_MysticTicket::
	setvaddress MysteryEventScript_MysticTicket
	lock
	faceplayer
	vgoto_if_set FLAG_RECEIVED_MYSTIC_TICKET, MysticTicket_Obtained
	vgoto_if_set FLAG_FOUGHT_LUGIA, MysticTicket_Obtained
	vgoto_if_set FLAG_FOUGHT_HO_OH, MysticTicket_Obtained
	checkitem ITEM_MYSTIC_TICKET, 1
	vgoto_if_eq VAR_RESULT, TRUE, MysticTicket_Obtained
	vmessage sText_MysticTicket2
	waitmessage
	waitbuttonpress
	checkitemspace ITEM_MYSTIC_TICKET, 1
	vgoto_if_eq VAR_RESULT, FALSE, MysticTicket_NoBagSpace
	giveitem ITEM_MYSTIC_TICKET
	setflag FLAG_ENABLE_SHIP_NAVEL_ROCK
	setflag FLAG_RECEIVED_MYSTIC_TICKET
	vmessage sText_MysticTicket1
	waitmessage
	waitbuttonpress
	release
	end

MysticTicket_NoBagSpace:
	vmessage sText_MysticTicketNoPlace
	waitmessage
	waitbuttonpress
	release
	end

MysticTicket_Obtained:
	vmessage sText_MysticTicketGot
	waitmessage
	waitbuttonpress
	release
	end

sText_MysticTicket2: @ 84896FF
	.string "Thank you for using the Mystery\n"
	.string "Gift System.\p"
	.string "You must be {PLAYER}.\n"
	.string "There is a ticket here for you.$"

sText_MysticTicket1:
	.string "It appears to be for use at the\n"
	.string "Vermilion City port.\p"
	.string "Why not give it a try and see what\n"
	.string "it is about?$"

sText_MysticTicketGot: @ 84897C1
	.string "Thank you for using the Mystery\n"
	.string "Gift System.$"

sText_MysticTicketNoPlace: @ 84897EE
	.string "Oh, I'm sorry, {PLAYER}. Your Bag's\n"
	.string "Key Items Pocket is full.\p"
	.string "Please store something on your PC,\n"
	.string "then come back for this.$"

MysteryEventScript_AlteringCave::
	setvaddress MysteryEventScript_AlteringCave
	addvar VAR_ALTERING_CAVE_WILD_SET, 1
	vgoto_if_ne VAR_ALTERING_CAVE_WILD_SET, 10, MysteryEventScript_AlteringCave_
	setvar VAR_ALTERING_CAVE_WILD_SET, 0
MysteryEventScript_AlteringCave_:
	lock
	faceplayer
	vmessage sText_MysteryGiftAlteringCave
	waitmessage
	waitbuttonpress
	release
	end

sText_MysteryGiftAlteringCave: @ 8489887
	.string "Thank you for using the Mystery\n"
	.string "Gift System.\p"
	.string "Recently, there have been rumors\n"
	.string "of rare Pokémon appearances.\p"
	.string "The rumors are about Altering\n"
	.string "Cave on Outcast Island.\p"
	.string "Why not visit there and check if\n"
	.string "the rumors are indeed true?$"
