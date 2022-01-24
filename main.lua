-----------------------------------------------------------------------------------------
--
-- main.lua Flappy Bird
--
-----------------------------------------------------------------------------------------
local function main()
    local physics = require("physics");
    physics.start();
    math.randomseed(os.time());
    print(math.random()); -- użycie math.random() raz, pierwsza liczba nie jest do końca losowa

    --[[
        kolejność deklaracji grup ma znaczenie dla kolejności wyświetlania elementów
        które w nich są, np żeby tło nie zasłaniało interfejsu, jest deklarowane jako
        pierwsze, a interfejs na końcu, żeby był na wierzchu
    ]]
    local bgGroup = display.newGroup();
    local mainGroup = display.newGroup();
    local uiGroup = display.newGroup();

    local canReset = false;
    -----------------------------------------------------------------------------------------

    local defeatText = display.newText(uiGroup,"",display.contentCenterX, display.contentCenterY-100, native.systemFont, 40);
    local score = 0
    local scoreText = display.newText(uiGroup,score,20, 20, native.systemFont, 30);

    local bg = display.newImageRect(bgGroup,"assets/sprites/bg.png",800,600);
    bg.x = display.contentCenterX;
    bg.y = display.contentCenterY;

    local platform = display.newImageRect(mainGroup,"assets/sprites/platform.png",800,200);
    platform.x = display.contentCenterX;
    platform.y = display.contentCenterY + bg.height/2.5;
    physics.addBody(platform,"static",{isSensor=true});

    local bird = display.newImageRect(mainGroup,"assets/sprites/yellowbird-upflap.png",55,40);
    bird.x = display.contentCenterX - 300;
    bird.y = display.contentCenterY - 170;
    physics.addBody(bird,"dynamic",{isSensor=true});
    local canJump = true

    local function birdJump()
        if canJump then
            canJump = false
            local vx, vy = bird:getLinearVelocity()
            bird:setLinearVelocity( vx, 0 )
            bird:applyLinearImpulse(0,-0.15,bird.x,bird.y);
            media.playSound("assets/audio/wing.wav");
            local function changeJumpState()
                canJump = true
            end
            timer.performWithDelay(300,changeJumpState);
        end
    end

    local barBottomLeft = display.newImageRect(mainGroup,"assets/sprites/pipe-green.png",60,400);
    physics.addBody(barBottomLeft,"dynamic",{isSensor=true});
    barBottomLeft.gravityScale = 0;

    local barTopLeft = display.newImageRect(mainGroup,"assets/sprites/pipe-green-top.png",60,400);
    physics.addBody(barTopLeft,"dynamic",{isSensor=true});
    local coinLeft = display.newImageRect(uiGroup,"assets/sprites/coin.png",25,25);
    physics.addBody(coinLeft,"dynamic",{isSensor=true});
    barTopLeft.gravityScale = 0;
    coinLeft.gravityScale = 0;

    local barBottomCenter = display.newImageRect(mainGroup,"assets/sprites/pipe-green.png",60,400);
    physics.addBody(barBottomCenter,"dynamic",{isSensor=true});
    barBottomCenter.gravityScale = 0;

    local barTopCenter = display.newImageRect(mainGroup,"assets/sprites/pipe-green-top.png",60,400);
    physics.addBody(barTopCenter,"dynamic",{isSensor=true});
    local coinCenter = display.newImageRect(uiGroup,"assets/sprites/coin.png",25,25);
    physics.addBody(coinCenter,"dynamic",{isSensor=true});
    barTopCenter.gravityScale = 0;
    coinCenter.gravityScale = 0;

    local barBottomRight = display.newImageRect(mainGroup,"assets/sprites/pipe-green.png",60,400);
    physics.addBody(barBottomRight,"dynamic",{isSensor=true});
    barBottomRight.gravityScale = 0;

    local barTopRight = display.newImageRect(mainGroup,"assets/sprites/pipe-green-top.png",60,400);
    physics.addBody(barTopRight,"dynamic",{isSensor=true});
    local coinRight = display.newImageRect(uiGroup,"assets/sprites/coin.png",25,25);
    physics.addBody(coinRight,"dynamic",{isSensor=true});
    barTopRight.gravityScale = 0;
    coinRight.gravityScale = 0;

    local function setBarsAndCoinsAtStartingPoints()
        barBottomLeft.x = display.contentCenterX + 300;
        barBottomLeft.y = display.contentCenterY + 150;
        barTopLeft.x = barBottomLeft.x;
        barTopLeft.y = barBottomLeft.y - 520;
        coinLeft.x = barBottomLeft.x;
        coinLeft.y = barBottomLeft.y - 250;
        barBottomCenter.x = display.contentCenterX + 99999;
        barBottomCenter.y = display.contentCenterY + 200;
        barTopCenter.x = barBottomCenter.x;
        barTopCenter.y = barBottomCenter.y - 520;
        coinCenter.x = barBottomCenter.x;
        coinCenter.y = barBottomCenter.y - 250;
        barBottomRight.x = display.contentCenterX + 99999;
        barBottomRight.y = display.contentCenterY + 170;
        barTopRight.x = barBottomRight.x;
        barTopRight.y = barBottomRight.y - 520;
        coinRight.x = barBottomRight.x;
        coinRight.y = barBottomRight.y - 250;    
    end

    setBarsAndCoinsAtStartingPoints();
    platform:toFront();

    local function collide(self, event)
        if ( event.phase == "began" and event.other ~= coinLeft and event.other ~= coinCenter and event.other ~= coinRight) then
            local function killBird()
                media.playSound("assets/audio/die.wav");
                bird.y = 21372137;
                defeatText.text = "Naciśnij Esc lub dotknij platformy";
                local function timerForReset()
                    canReset = true;
                end
                timer.performWithDelay(2000,timerForReset);
                canJump = false;
            end
            timer.performWithDelay(10, killBird);
        elseif ( event.phase == "began" and (event.other == coinLeft or event.other == coinCenter or event.other == coinRight)) then
            local function addScore()
                event.other.y = 2137;
                media.playSound("assets/audio/point.wav");
                score = score + 1;
                scoreText.text = score;
            end
            timer.performWithDelay(10, addScore);
        end
    end

    bird.collision = collide
    bird:addEventListener("collision")

    local barCollisionCatcher = display.newImageRect(uiGroup,"assets/sprites/pipe-collision-catcher.png",10,600);
    barCollisionCatcher.x = -11;
    barCollisionCatcher.y = bg.y;
    physics.addBody(barCollisionCatcher,"static");
    barCollisionCatcher.alpha = 0;

    barBottomLeft:setLinearVelocity(-86,0);
    barTopLeft:setLinearVelocity(-86,0);
    barBottomRight:setLinearVelocity(-86,0);
    barTopRight:setLinearVelocity(-86,0);
    barBottomCenter:setLinearVelocity(-86,0);
    barTopCenter:setLinearVelocity(-86,0);
    coinLeft:setLinearVelocity(-86,0);
    coinCenter:setLinearVelocity(-86,0);
    coinRight:setLinearVelocity(-86,0);

    local function barCollide(self, event)
        if ( event.phase == "began" and (event.other == barBottomLeft or event.other == barTopLeft or event.other == barBottomCenter or event.other == barTopCenter or event.other == barBottomRight or event.other == barTopRight)) then
            local function teleportBar()
                if event.other == barBottomLeft then
                    barBottomLeft.x = display.contentCenterX + 400;
                    barTopLeft.x = display.contentCenterX + 400;
                    barBottomLeft.y = display.contentCenterY + math.random(100,250);
                    barTopLeft.y = barBottomLeft.y - 520;
                    coinLeft.y = barBottomLeft.y - 250;
                    coinLeft.x = barBottomLeft.x;
                elseif event.other == barBottomCenter then
                    barBottomCenter.x = display.contentCenterX + 400;
                    barTopCenter.x = display.contentCenterX + 400;
                    barBottomCenter.y = display.contentCenterY + math.random(100,250);
                    barTopCenter.y = barBottomCenter.y - 520;
                    coinCenter.y = barBottomCenter.y - 250;
                    coinCenter.x = barBottomCenter.x;
                elseif event.other == barBottomRight then
                    barBottomRight.x = display.contentCenterX + 400;
                    barTopRight.x = display.contentCenterX + 400;
                    barBottomRight.y = display.contentCenterY + math.random(100,250);
                    barTopRight.y = barBottomRight.y - 520;
                    coinRight.y = barBottomRight.y - 250;
                    coinRight.x = barBottomRight.x;
                else end
            end
        timer.performWithDelay(10, teleportBar);
        end
    end

    barCollisionCatcher.collision = barCollide
    barCollisionCatcher:addEventListener("collision")

    --local function teleportBars()
        -- poruszanie się zastąpione przez setLinearVelocity i gravityScale
        -- "teleportowanie" rur na prawą stronę zastąpione przez barCollisionCatcher
        --[[speed = 3
        barBottomLeft.x = barBottomLeft.x - speed;
        barTopLeft.x = barTopLeft.x - speed;
        barBottomCenter.x = barBottomCenter.x - speed;
        barTopCenter.x = barTopCenter.x - speed;
        barBottomRight.x = barBottomRight.x - speed;
        barTopRight.x = barTopRight.x - speed;
        coinLeft.x = coinLeft.x - speed;
        coinCenter.x = coinCenter.x - speed;
        coinRight.x = coinRight.x - speed;
        if barBottomLeft.x < 30 then
            barBottomLeft.x = display.contentCenterX + 400;
            barTopLeft.x = display.contentCenterX + 400;
            barBottomLeft.y = display.contentCenterY + math.random(100,250);
            barTopLeft.y = barBottomLeft.y - 520;
            coinLeft.y = barBottomLeft.y - 250;
            coinLeft.x = barBottomLeft.x;
        end
        if barBottomCenter.x < 30 then
            barBottomCenter.x = display.contentCenterX + 400;
            barTopCenter.x = display.contentCenterX + 400;
            barBottomCenter.y = display.contentCenterY + math.random(100,250);
            barTopCenter.y = barBottomCenter.y - 520;
            coinCenter.y = barBottomCenter.y - 250;
            coinCenter.x = barBottomCenter.x;
        end
        if barBottomRight.x < 30 then
            barBottomRight.x = display.contentCenterX + 400;
            barTopRight.x = display.contentCenterX + 400;
            barBottomRight.y = display.contentCenterY + math.random(100,250);
            barTopRight.y = barBottomRight.y - 520;
            coinRight.y = barBottomRight.y - 250;
            coinRight.x = barBottomRight.x;
        end]]
    --end

    local function initCenterBars()
        barBottomCenter.x = display.contentCenterX + 400;
        barTopCenter.x = barBottomCenter.x;
        coinCenter.y = barBottomCenter.y - 250;
        coinCenter.x = barBottomCenter.x;
    end

    local function initRightBars()
        barBottomRight.x = display.contentCenterX + 400;
        barTopRight.x = barBottomRight.x;
        coinRight.y = barBottomRight.y - 250;
        coinRight.x = barBottomRight.x;
    end

    -- timer niepotrzebny ze względu na użycie wydajniejszych metod ruchu
    --timer.performWithDelay(300,teleportBars,-1);
    timer.performWithDelay(1750,initCenterBars);
    timer.performWithDelay(4666,initRightBars);

    local function gameReset()
        if canReset == true then
            canReset = false;
            canJump = true;
            score = 0;
            scoreText.text = score;
            defeatText.text = "";
            local vx, vy = bird:getLinearVelocity();
            bird:setLinearVelocity( vx, 0 );
            bird.x = display.contentCenterX - 300;
            bird.y = display.contentCenterY - 170;
            setBarsAndCoinsAtStartingPoints();
            timer.performWithDelay(1750,initCenterBars);
            timer.performWithDelay(4666,initRightBars);
            --[[local function timerForReset()
                canReset = true;
            end
            timer.performWithDelay(5000,timerForReset);]]
        end
    end
    
    local function keyDown(event)
        if event.keyName == "space" then birdJump()
        elseif event.keyName == "escape" then gameReset()
        end
    end
    
    Runtime:addEventListener("key", keyDown);
    platform:addEventListener("tap", birdJump);
    platform:addEventListener("tap", gameReset);
end

timer.performWithDelay(3500,main);
